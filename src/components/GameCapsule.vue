<template lang="pug">
.col-1(@mouseover.once="loadDetails")
	.GameCapsule--container(v-if="image==='library'")
		q-img.GameCapsule(:src="library" @error="image='hero_capsule'")

	.GameCapsule--container(v-if="image==='hero_capsule'")
		q-img.GameCapsule(:src="hero_capsule" @error="image='header'")

	.GameCapsule--container(v-if="image==='header'")
		.GameCapsule--background(:style="{ 'background-image': 'url(' + header + ')' }")
		q-img.GameCapsule(:src="header" @error="image='error'")

	.GameCapsule--container(v-if="image==='error'")
		.text-center {{ appDetails.name || appid }}
	
	q-tooltip.DetailsTooltip(max-width="20em")
		b {{ appDetails.name }}
		.q-mt-md(v-html="appDetails.short_description")
</template>

<script>
import { defineComponent } from "vue"
import axios from "axios"

export default defineComponent({
	props: {
		appid: {
			type: Number,
			required: true,
		},
	},
	data() {
		return {
			image: "library",
			appDetails: {},
		}
	},
	computed: {
		library() {
			return `https://cdn.cloudflare.steamstatic.com/steam/apps/${this.appid}/library_600x900_2x.jpg`
		},
		hero_capsule() {
			return `https://cdn.cloudflare.steamstatic.com/steam/apps/${this.appid}/hero_capsule.jpg`
		},
		header() {
			return `https://cdn.cloudflare.steamstatic.com/steam/apps/${this.appid}/header.jpg`
		},
	},
	methods: {
		loadDetails() {
			axios(`/storeapi/appdetails?appids=${this.appid}`).then(response => {
				this.appDetails = response.data[this.appid].data
			})
		},
	},
})
</script>
<style lang="scss">
.GameCapsule {
	grid-area: 1 / 1 / 2 / 2;
	&--container {
		width: 100%;
		aspect-ratio: 6 / 9;
		background-color: #fff;
		display: grid;
		align-items: center;
		overflow: hidden;
	}
	&--background {
		width: 100%;
		height: 100%;
		grid-area: 1 / 1 / 2 / 2;
		background-size: 100% 100%;
		filter: blur(15px);
	}
}
.DetailsTooltip {
	font-size: 1em;
}
</style>
