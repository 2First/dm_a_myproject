<template>
<div>
    <div>
<BookInfo :info='info'></BookInfo>
    </div>
<div class="comment">
    <textarea v-model='comment'
              class='textarea'
              :maxlength='100'
              placeholder='请输入图书短评'></textarea>
     
     <div class='location'>
             地理位置：
             <switch color='#EA5A49' :checked='location' @change='getGeo'> </switch>
             <span class='text-primary'>{{location}}</span>
     </div>
     <div class='phone'>
             手机型号:
             <switch color='#EA5A49' :checked='phone'  @change='getPhone'> </switch>
             <span class='text-primary'>{{phone}}</span>
     </div>
     <button class="btn" @click='addComment'>
         评论
     </button>
</div>
</div>
</template>
<script>
import {get,post,showModal} from '@/util'
import BookInfo from '@/components/BookInfo'
import { generateKeyPairSync } from 'crypto';
export default {
    components:{
        BookInfo
    },
    data(){
        return{
       comments:[],
       userinfo: {},
       bookid:'',
       info:{},
       comment:'',
       location:'',
       phone:''
        }
   
    },
    methods:{
       async addComment(){
            if(!this.comment){
                return
            }
            const data = {
               openid: this.userinfo.openId,
               bookid: this.bookid,
               comment: this.comment,
               phone: this.phone,
               location: this.location
            }
            try{
              await post('/weapp/addcomment',data)
              this.comment = ''
            } catch(e){
                showModal('失败',e.msg)
            }
           
            console.log(data)
        },
        async getDetail(){
            const info = await get('/weapp/bookdetail',{id:this.bookid})
            
            wx.setNavigationBarTitle({
                title:info.title
            })
            this.info = info
            console.log(info)
        },
        async getComments(){
            const comments = await get('/weapp/commentlist',{bookid:this.bookid})
            this.comments = comments
        },

    getGeo (e) {
      const ak = '8hN7DFRwmGzZXPayCPkVGEz7j18HD977'
      let url = 'http://api.map.baidu.com/geocoder/v2/'

      if (e.target.value) {
        wx.getLocation({
          success: geo => {
            wx.request({
              url,
              data: {
                ak,
                location: `${geo.latitude},${geo.longitude}`,
                output: 'json'
              },
              success: res => {
                console.log(res)
                if (res.data.status === 0) {
                  this.location = res.data.result.addressComponent.city
                } else {
                  this.location = '未知地点'
                  // console.log('出错了')
                }
              }
            })
          }
        })
      } else {
        this.location = ''
      }
    },
        getPhone(e){
            console.log('手机型号获取中')
            if(e.target.value){
                const phoneInfo = wx.getSystemInfoSync() 
                console.log(phoneInfo)
                this.phone = phoneInfo.model
        }else{
             this.phone=''
        }  
      }  
    },
    
mounted(){
    this.bookid = this.$root.$mp.query.id
    this.getDetail()
    this.getComments()
    const userinfo = wx.getStorageSync('userinfo')
    console.log('userinfo', userinfo)
     if (userinfo) {
      this.userinfo = userinfo
    }
        }
    
  }  
</script>
<style lang='scss'>
.comment{
    margin-top:10px;
    .textarea{
        width: 730rpx;
        height: 200rpx;
        background: #eee;
        padding: 10rpx;
    }
    .location{
    margin-top:10px;
    padding:5px 10px;
  }
  .phone{
    margin-top:10px;
    padding:5px 10px;
    
  }
}

</style>
