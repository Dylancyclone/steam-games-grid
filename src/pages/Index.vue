<template lang="pug">
q-page.flex.flex-center
	q-header.row.justify-between.q-pa-md(elevated)
		div
		q-input.SearchBar(dark dense standout v-model='search')
			template(#append)
				q-icon(name="search")
		.q-gutter-x-sm
			q-btn(v-if="this.errors.length > 0" flat round @click="warning" icon='warning' color="warning")
			q-btn(flat round @click="settings" icon='settings')
	.absolute-full.row.q-pa-lg.q-gutter-md
		GameCapsule(v-for="game in searchedIds" :appid="game.appid || game.obj.appid")
</template>

<script>
import { defineComponent, isProxy, toRaw } from "vue"
import { QSpinnerDots } from "quasar"
import axios from "axios"
import GameCapsule from "../components/GameCapsule.vue"
import fuzzysort from "fuzzysort"

export default defineComponent({
	name: "PageIndex",
	components: { GameCapsule },
	data() {
		return {
			search: "",
			allApps: [],
			games: [],
			errors: [],

			gameIds: [],
		}
	},
	computed: {
		filteredIds() {
			return this.allApps
				.filter(app => this.gameIds.includes(app.appid))
				.sort((a, b) => {
					return a.name.localeCompare(b.name)
				})
		},
		searchedIds() {
			if (!this.search) return this.filteredIds
			return fuzzysort.go(this.search, this.filteredIds, { key: "name" })
		},
	},
	mounted() {
		axios("/api/ISteamApps/GetAppList/v0002/").then(response => {
			this.allApps = response.data.applist.apps
			// this.allApps.forEach(el => (el.filePrepared = fuzzysort.prepare(el.name)))
			console.log(this.allApps[0])
			console.log(isProxy(this.allApps[0]))
			console.log(toRaw(this.allApps[0]))

			if (this.$route.params.data) {
				this.gameIds = this.$route.params.data
					.split(",")
					.map(el => parseInt(el))
			}
		})
	},
	methods: {
		settings() {
			this.$q
				.dialog({
					title: "Change games",
					message: "Paste a list of games, one game per line",
					prompt: {
						model: "",
						type: "textarea",
					},
					cancel: true,
					persistent: true,
				})
				.onOk(data => {
					this.$q.loading.show({
						spinner: QSpinnerDots,
						spinnerColor: "secondary",
						message: "Loading, this may take a few seconds...",
					})
					this.games = data.split(/\r?\n/)

					setTimeout(() => {
						this.gameIds = []
						this.games.map(game => {
							let test = fuzzysort.go(game, this.allApps, {
								key: "name",
								limit: 1,
							})[0]
							// console.log(test)
							if (!!test?.obj) {
								this.gameIds.push(test.obj.appid)
							} else {
								this.errors.push(game)
							}
						})
						this.$router.replace({
							name: this.$route.name,
							params: { data: this.gameIds.join(",") },
						})
						this.$q.loading.hide()
					}, 100)
				})
		},
		warning() {
			this.$q.dialog({
				title: "Warning",
				html: true,
				message:
					"The following games were not found:<br>" + this.errors.join("<br>"),
			})
		},
	},
})
</script>
<style lang="scss">
.SearchBar {
	width: 25%;
}
</style>
