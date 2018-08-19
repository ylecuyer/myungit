<template>
<p>Repo: {{path}}</p>
</template>

<script>
export default {
  data() {
    return {
      path: this.$route.query.path
    }
  }
}
</script>
