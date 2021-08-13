<!-- Template içerisinde yalnızca sadece bir kök eleman olabilir. Adı üzerinde kök (root) bir tane olması gerekiyor ve diğer çocuk düğümleri kapsamalı. -->
<template>
    <div class="item">
        <img v-bind:src="IMG" v-bind:alt="NAME" @click="goToSeries(NAME)">
    </div>
</template>

<script>

export default {
  name: 'Poster',
  props: ['IMG', 'NAME'],
  components: {
    
  },
  data() {
      return {
          // Burada değişkenleri tanımlıyorsun oluşturucu sınıf gibi düşün ama değişkenlere erişim sağlarken this anahtar kelimesini kullan
      }
  },
  methods: {
    // Burada sayfa içinde eventlar yardımı ile çağrılabilecek fonksiyonlar tanımlanablir.
    // Tabi daha iyi kod örneği elde edebilmek amacıyla bu kod services klasörü altında export edilecek şekilde yazılabilir.
    goToSeries(name){
      location.href = location.origin + "/Dizi/" + this.generateURL(name);
    },
    generateURL(name){
      name = name.replaceAll(' ', '-');
      return name;
    }
  },
  mounted () { // Vue için Özel event // bileşen uygulamaya eklendiği zaman tetiklenir.
    // this.getUsers();
  }
}
</script>