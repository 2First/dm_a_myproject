<template>
<div>
    <TopSwiper :tops='tops'></TopSwiper>
<Card :key='book.id' v-for='book in books' :book='book'></Card>
<p class='text-footer' v-if='!more'>
    没有更多数据
</p>
</div>
</template>

<script>
import {get} from '@/util'
import Card from '@/components/Card'
import TopSwiper  from '@/components/TopSwiper'
import { log } from 'util';
export default {
    components:{
        Card,
        TopSwiper
    },
data(){
    return {
        books:[],
        page:0,
        more:true,
        tops:[]
    }
},
methods:{
    async getList(init){
        if (init){
            this.page = 0
            this.more = true
        }
        wx.showNavigationBarLoading()
        const books = await get('/weapp/booklist',{page:this.page})
        this.books = books.list
        if(books.list.length<10 && this.page>0){
            this.more = false
            console,log(this.more)
        }
        if(init){
            this.books = books.list
            wx.stopPullDownRefresh()
        }else{
            this.books = this.books.concat(books.list)
        }
        
        wx.hideNavigationBarLoading()
    },
    async getTop(){
        const tops = await get('/weapp/top')
        this.tops = tops.list
    }
},
onPullDownRefresh(){
    this.getList(true)
    this.getTop()
},
onReachBottom(){
     if(!this.more){
         return false
     }
     this.page = this.page+1
     this.getList()
},
mounted(){
    this.getList(true)
    this.getTop()
}
}
</script>
<style lang='scss'>
</style>