<template>
<div class="container">
    <div class="userinfo">
    <img :src="userinfo.avatarUrl" alt="">      
    <p>
        {{userinfo.nickName}}
    </p>
</div>
<yearprogress>
    
</yearprogress>
<button v-if="userinfo.openId" @click="scanBook" class="btn">
添加图书     
</button>

<button v-else @getuserinfo ="login" class="btn" lang="zh_CN" open-type="getUserInfo">
点击登陆
</button>
</div>
</template>
<script>
import qcloud from 'wafer2-client-sdk'
import yearprogress from '@/components/yearprogress'
import {showSuccess, post, showModal} from '@/util'
import config from '@/config'
import { log } from 'util';

export default {
  components: {
    yearprogress
  },
  data () {
    return {
      userinfo: {
        avatarUrl: '../../../static/img/unlogin.png',
        nickName: ''
      }
    }
  },
  methods: {
    async addBook (isbn) {
      const res = await post('/weapp/addbook', {
        isbn,
        openid: this.userinfo.openId
      })
      console.log(res)
      showModal('添加成功', '${res.title}添加成功')
      
    },
    scanBook () {
      wx.scanCode({
        success: (res) => {
          if (res.result) {
            this.addBook(res.result)
          }
        }
      })
    },
    login () {
      let user = wx.getStorageSync('userinfo')
      const self = this
     
      if (!user) {
        qcloud.setLoginUrl(config.loginUrl)
        qcloud.login({
          success: function (userinfo) {
            qcloud.request({
              url: config.userUrl,
              login: true,
              success (userRes) {
                showSuccess('登陆成功', userRes)
                wx.setStorageSync('userinfo', userRes.data.data)
                self.userinfo = userRes.data.data
              }
            })
          }
        })
      }
    }
    
  },

  onShow () {
    let userinfo = wx.getStorageSync('userinfo')
    if (userinfo) {
      this.userinfo = userinfo
    }
  }
}
</script>
<style lang = "scss">
.container{
    padding: 0 30rpx;
}
.userinfo{
    margin-top: 100rpx;
    text-align: center;
    img{
        width: 150rpx;
        height: 150rpx;
        margin: 20rpx;
        border-radius: 50%;
    }
}
</style>
