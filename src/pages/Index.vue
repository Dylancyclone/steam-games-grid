<template lang="pug">
q-page.flex.flex-center
	q-header.row.justify-around.q-pa-md(elevated)
		q-input(dark dense standout v-model='search')
			template(#append)
				q-icon(name="search")
</template>

<script>
import { defineComponent } from "vue"

export default defineComponent({
	name: "PageIndex",

	data() {
		return {
			search: "",
		}
	},
})
</script>
