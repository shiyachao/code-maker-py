<template>
  <pageBase>
    <div class="page-content" ref="pageContent">
      <div class="search-wrap">
        <a-form-model v-bind="searchFormLayout">
          <a-row :gutter="10">
            <a-col :span="5">
              <a-form-model-item label="基础数据主键">
                <a-input v-model="searchCommand.codeMapId" placeholder="请输入基础数据主键"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="5">
              <a-form-model-item label="基础数据名称">
                <a-input v-model="searchCommand.codeMapName" placeholder="请输入基础数据名称"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="5">
              <a-form-model-item label="基础数据类型">
                <a-select v-model="searchCommand.codeType" placeholder="请选择基础数据类型" :options="codeTypeList"/>
              </a-form-model-item>
            </a-col>
            <a-col :span="5">
              <a-form-model-item label="状态">
                <a-select v-model="searchCommand.status" placeholder="请选择状态" :options="statusList"/>
              </a-form-model-item>
            </a-col>
            <a-col :span="5">
              <a-form-model-item label="创建时间">
                <a-date-picker v-model="searchCommand.regTime" format="yyyy-MM-DD" ></a-date-picker>
              </a-form-model-item>
            </a-col>
            <a-col :span="5">
              <a-form-model-item label="更新时间">
                <a-date-picker v-model="searchCommand.updTime" format="yyyy-MM-DD" ></a-date-picker>
              </a-form-model-item>
            </a-col>
            <a-col :span="4">
              <a-form-model-item>
                <a-button type="primary" @click="setSearch">查询</a-button>
              </a-form-model-item>
            </a-col>
          </a-row>
        </a-form-model>
      </div>
      <div class="table-wrap" ref="tableWrap">
        <div class="table-toolbar">
          <div>
            <a-button type="primary" @click="$refs.addCodeMap.show()">新增</a-button>
          </div>
          <div>
            <a-button>上传</a-button>
          </div>
        </div>
        <a-table rowKey="codeMapId" :columns="columns" :pagination="pagination" :dataSource="dataSource" @change="tableChange" :scroll="{}">
          <div class="order-wrap" slot="order" slot-scope="text,record">
            <a href="javascript:void(0)" @click="$refs.addCodeMap.show(record.codeMapId)">修改</a>
            <a-popconfirm title="是否确认删除？" @confirm="del(record.codeMapId)">
              <a href="javascript:void(0)">删除</a>
            </a-popconfirm>
          </div>
        </a-table>
      </div>
    </div>
    <addCodeMap ref="addCodeMap" @finish="setSearch" />
  </pageBase>
</template>

<script>
import addCodeMap from './module/addCodeMap';
import { listCodeMap,delCodeMap } from "@/api/codeMap";
export default {
  name: "codeMap",
  data() {
    return {
      codeTypeList:[{'value': '00', 'label': '人员类别'}],
      statusList:[{'value': '00', 'label': '正常'}, {'value': '99', 'label': '停用'}],
      columns:[
        { title: "基础数据主键", dataIndex:"codeMapId"},
        { title: "基础数据名称", dataIndex:"codeMapName"},
        { title: "基础数据类型", dataIndex:"codeTypeCn"},
        { title: "状态", dataIndex:"statusCn"},
        { title: "创建时间", dataIndex:"regTime"},
        { title: "更新时间", dataIndex:"updTime"},
        { title: "操作", align:"center", scopedSlots: { customRender: 'order'}},
      ],
      dataSource:[
        
      ],
      pagination:{...this.defaultPagination},
      searchCommand:{
        codeType: '00',
        status: '00',
      },
    }
  },
  components: {
    addCodeMap
  },
  created(){
    this.setSearch();
  },
  methods:{
    tableChange(pagination){
      this.pagination = pagination;
      this.getCodeMap();
    },
    setSearch(){
      this.pagination.current = 1;
      this.getCodeMap();
    },
    getCodeMap(){
      listCodeMap({...this.searchCommand,current:this.pagination.current,pageSize:this.pagination.pageSize}).then(res=>{
        this.dataSource = res.data;
        this.pagination.total = res.total;
      })
    },
    del(codeMapId){
      delCodeMap(codeMapId).then(()=>{
        this.setSearch();
      })
    }
  }
}
</script>

<style lang="less" scoped>
.page-content{
  display: flex;
  flex-direction: column;
  padding:10px;
}
</style>
