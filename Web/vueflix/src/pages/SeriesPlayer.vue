<template>
<div>
  <div ref="videoContainer" class="container shadow-lg mx-auto max-w-full size">
    <video
      id="video"
      ref="videoPlayer"
      class="w-full h-full"
      :poster="posterUrl"
    ></video>
  </div>

</div>
</template>

<script>
import { getVideoSourceByEpisode } from '../services/VideoSourceService'

import PerfectScrollbar from 'perfect-scrollbar'
import 'perfect-scrollbar/css/perfect-scrollbar.css'

import ShakaPlayer from 'shaka-player/dist/shaka-player.ui.js'
import 'shaka-player/dist/controls.css'

export default {
  name: 'SeriesDetail',
  props: ["name","season","episode"],
  components: {
  },
  data() {
      return {
          seriesName: "",
          posterURL: "",
          about: "",
          seasons: [],
      }
  },
  methods: {
    getVideoSource(){
        getVideoSourceByEpisode(this.season, this.episode).then(response => {
            console.log(response);
            this.posterURL = response['data']['series'][0].posterURL;
            this.seriesName = response['data']['series'][0].name;
            this.about = response['data']['series'][0].about;//Array.from(categories, x => x.name);
            this.seasons = response['data']['series'][0]['seasons'];
        })
    },
    URLtoSTR(url){
      return url.replaceAll('-', ' ');
    },
    perfectScrollBarInit(){
      new PerfectScrollbar('#SeriesDetailText', {
          wheelSpeed: 2,
          wheelPropagation: true,
          minScrollbarLength: 20
      });
    },
    videoPlayerInit(){
      const player = new ShakaPlayer.Player(this.$refs.videoPlayer);
      const ui = new shaka.ui.Overlay(
        player,
        this.$refs.videoContainer,
        this.$refs.videoPlayer
      );
      ui.getControls();

      player.configure({
      drm: {
        servers: { 'com.widevine.alpha': this.licenseServer }
      }
    });
    player
      .load(this.manifestUrl)
      .then(() => {
        // This runs if the asynchronous load is successful.
        console.log('The video has now been loaded!');
      })
      .catch(this.onError); // onError is executed if the asynchronous load fails.
    }
  },
  mounted () {
    this.getDetail();
    this.perfectScrollBarInit();
  }
}
</script>