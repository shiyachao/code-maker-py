<template>
  <a-modal
    :visible="visible"
    :title="(isEdit?'修改':'新建')+'${tableComment}'"
    width="700px"
    @ok="ok"
    @cancel="hide"
  >
    <a-form-model :model="command" :rules="rules" v-bind="formLayout" ref="${tableName}Form">
	  % for item in columns:
<%
	commentName = item['commentName'] or item['fieldComment']
	fieldName = item['fieldName']
	javaType = item['javaType']
%>\
      % if fieldName not in ['regTime', 'updTime']:
      % if item['isPri']:
      <a-form-model-item v-if="!isEdit" label="${commentName}" prop="${fieldName}" extra="非必要请不要填写，默认生成">
      % else:
      <a-form-model-item label="${commentName}" prop="${fieldName}">
      % endif
        % if javaType == 'Date':
        <a-date-picker v-model="command.${fieldName}" valueFormat="yyyy-MM-DD" ></a-date-picker>
		% elif item['commentEnum']:
        <a-select v-model="command.${fieldName}" placeholder="请选择${commentName}" :options="${fieldName}List"></a-select>
		% elif javaType == 'BigDecimal':
        <a-input-number v-model="command.${fieldName}" placeholder="请输入${commentName}" :max="${'9' * int(item['max'])}.${'9' * int(item['pointMax'])}" :min="0" :step="${1 / 10**int(item['pointMax'])}" :precision="${item['pointMax']}"></a-input-number>
		% elif 'max' in item:
		    %if int(item['max']) > 50:
        <a-textarea :autoSize="{minRows:3,maxRows:6}" v-model="command.${fieldName}" placeholder="请输入${commentName}" :maxLength="${int(item['max'])}"></a-textarea>
            % else:
        <a-input v-model="command.${fieldName}" placeholder="请输入${commentName}" :maxLength="${int(item['max'])}"></a-input>
            % endif
        % else:
        <a-input v-model="command.${fieldName}" placeholder="请输入${commentName}"></a-input>
		% endif
      </a-form-model-item>
      % endif
	  % endfor
    </a-form-model>
  </a-modal>
</template>

<script>
import { add${capTableName}, edit${capTableName}, single${capTableName} } from '@/api/${tableName}';
const defaultCommand = {
  % for item in enums:
  ${item['fieldName']}: '${item['commentEnum'][0]['value']}',
  % endfor
}
export default {
  name: "add${capTableName}",
  data() {
    return {
      visible:false,
      isEdit:false,
	  % for item in enums:
      ${item['fieldName']}List:${item['commentEnum']},
	  % endfor
      command:{...defaultCommand},
      rules:{
		% for item in columns:
<%
	commentName = item['commentName'] or item['fieldComment']
	fieldName = item['fieldName']
	javaType = item['javaType']
	msg = "请选择" if javaType == "Date" or item['commentEnum'] else "请输入"
%>\
		  % if not item['blank'] and not item['isPri'] and fieldName not in ['regTime', 'updTime']:
        ${fieldName}:[{required:true,message:"${msg}${commentName}"}],
		  % endif
		% endfor
      },
      formLayout:{
        labelCol:{span:6},
        wrapperCol:{span:14},
      },
    }
  },
  components: {

  },
  methods:{
    show(${primary['fieldName']}){
      this.isEdit = !!${primary['fieldName']};
      if(this.isEdit){
        single${capTableName}(${primary['fieldName']}).then(res=>{
          this.command = res.data;
          this.visible = true;
        })
      }else{
        this.visible = true;
      }
    },
    ok(){
       this.$refs.${tableName}Form.validate(success=>{
        if(success){
          let request;
          if(this.isEdit){
            request = edit${capTableName}(this.command.${primary['fieldName']}, this.command);
          }else{
            request = add${capTableName}(this.command);
          }
          request.then(()=>{
            this.$emit("finish");
            this.hide();
          })
        }
      })
    },
    hide(){
      this.command = {...defaultCommand};
      this.visible = false;
    }
  }
}
</script>

<style lang="less" scoped>
</style>
