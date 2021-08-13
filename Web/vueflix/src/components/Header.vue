<template>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="/">Fluflix</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarText">
        <ul class="navbar-nav mr-auto">
        <li class="nav-item active">
            <v-link class="nav-link" href="/">Anasayfa</v-link>
        </li>
        <li class="nav-item">
            <v-link class="nav-link" href="/Kategoriler">Kategoriler</v-link>
        </li>
        <li class="nav-item">
            <v-link class="nav-link" href="/Hakkinda">Hakkında</v-link>
        </li>
        </ul>
    </div>
    </nav>
</template>

<script>
    import VLink from './VLink.vue'
    export default {
        name: 'Header',
        components: {
            VLink
        }
    }
</script>