<%!
  def enumList(columns):
	result = []
	for item in columns:
	  if item['commentEnum']:
		result.append(item)
	return result;
%>\
<template>
  <pageBase>
    <div class="page-content" ref="pageContent">
      <div class="search-wrap">
        <a-form-model v-bind="searchFormLayout">
          <a-row :gutter="10">
			% for item in columns:
<%
	commentName = item['commentName'] or item['fieldComment']
	fieldName = item['fieldName']
%>\
            <a-col :span="5">
              <a-form-model-item label="${commentName}">
				% if item['javaType'] == 'Date':
                <a-date-picker v-model="searchCommand.${fieldName}" format="yyyy-MM-DD" ></a-date-picker>
				% elif item['commentEnum']:
                <a-select v-model="searchCommand.${fieldName}" placeholder="请选择${commentName}" :options="${fieldName}List"/>
				% else:
                <a-input v-model="searchCommand.${fieldName}" placeholder="请输入${commentName}"></a-input>
				% endif
              </a-form-model-item>
            </a-col>
			% endfor
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
            <a-button type="primary" @click="$refs.add${capTableName}.show()">新增</a-button>
          </div>
          <div>
            <a-button>上传</a-button>
          </div>
        </div>
        <a-table rowKey="${primary['fieldName']}" :columns="columns" :pagination="pagination" :dataSource="dataSource" @change="tableChange" :scroll="{}">
          <div class="order-wrap" slot="order" slot-scope="text,record">
            <a href="javascript:void(0)" @click="$refs.add${capTableName}.show(record.${primary['fieldName']})">修改</a>
            <a-popconfirm title="是否确认删除？" @confirm="del(record.${primary['fieldName']})">
              <a href="javascript:void(0)">删除</a>
            </a-popconfirm>
          </div>
        </a-table>
      </div>
    </div>
    <add${capTableName} ref="add${capTableName}" @finish="setSearch" />
  </pageBase>
</template>

<script>
import add${capTableName} from './module/add${capTableName}';
import { list${capTableName},del${capTableName} } from "@/api/${tableName}";
export default {
  name: "${tableName}",
  data() {
    return {
	  % for item in enumList(columns):
      ${item['fieldName']}List:${item['commentEnum']},
	  % endfor
      columns:[
        % for item in columns:
<%
	commentName = item['commentName'] or item['fieldComment']
	fieldName = item['fieldName']+'Cn' if item['commentEnum'] else item['fieldName']
%>\
        { title: "${commentName}", dataIndex:"${fieldName}"},
		% endfor
        { title: "操作", align:"center", scopedSlots: { customRender: 'order'}},
      ],
      dataSource:[
        
      ],
      pagination:{...this.defaultPagination},
      searchCommand:{
        % for item in enums:
        ${item['fieldName']}: '${item['commentEnum'][0]['value']}',
        % endfor
      },
    }
  },
  components: {
    add${capTableName}
  },
  created(){
    this.setSearch();
  },
  methods:{
    tableChange(pagination){
      this.pagination = pagination;
      this.get${capTableName}();
    },
    setSearch(){
      this.pagination.current = 1;
      this.get${capTableName}();
    },
    get${capTableName}(){
      list${capTableName}({...this.searchCommand,current:this.pagination.current,pageSize:this.pagination.pageSize}).then(res=>{
        this.dataSource = res.data;
        this.pagination.total = res.total;
      })
    },
    del(${primary['fieldName']}){
      del${capTableName}(${primary['fieldName']}).then(()=>{
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
