<template>
  <div id="app">
    <router-view :key="$route.fullPath"/>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      profile: {},
      msg: "", 
      
    };
  },
  beforeCreate() {
    if (window.liff) {
      window.liff.init({
        liffId: '2005419810-weQvN4rd'
      }).then(() => {
        this.getProfile();
      }).catch((error) => {
        console.error('LIFF 初始化失敗', error);
      });
    } else {
      console.error('LIFF SDK 無法使用');
    }
  },
  methods: {

    getProfile() {
      if (window.liff.isLoggedIn()) {
        window.liff.getProfile().then((profile) => {
          this.profile = profile;
          this.$root.$userId = profile.userId;
          this.$root.$userName = profile.displayName;//6/2
        }).catch((error) => {
          console.error('獲取Profile失敗', error);
        });
      } else {
        window.liff.login();
      }
    }
  }
};
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
