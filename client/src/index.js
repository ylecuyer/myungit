import Vue from 'vue';
import VueRouter from 'vue-router';
import VueNativeSocket from 'vue-native-websocket'

import App from './components/app.vue'
import Repository from './components/repository.vue'

Vue.use(VueRouter);
Vue.use(VueNativeSocket, 'ws://localhost:8443', { format: 'json' })

const routes = [
  { path: '/repository', component: Repository },
]

const router = new VueRouter({
  routes
})

const app = new Vue({
  router,
  render: h => h(App)
}).$mount('#app')

app.$options.sockets.onmessage = (data) => console.log(data)
app.$options.sockets.onerror = (data) => console.log(data)

app.$options.sockets.onopen = (data) => {
  console.log(data)
  console.log(app.$socket)
  app.$socket.sendObj({
    action: 'setRepoPath',
    path: app.$route.query.path
  })
}

app.$options.sockets.onclose = (data) => console.log(data)

