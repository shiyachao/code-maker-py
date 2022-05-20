<template>
  <a-modal
    :visible="visible"
    :title="(isEdit?'修改':'新建')+'基础数据'"
    width="700px"
    @ok="ok"
    @cancel="hide"
  >
    <a-form-model :model="command" :rules="rules" v-bind="formLayout" ref="codeMapForm">
      <a-form-model-item v-if="!isEdit" label="基础数据主键" prop="codeMapId" extra="非必要请不要填写，默认生成">
        <a-input v-model="command.codeMapId" placeholder="请输入基础数据主键" :maxLength="36"></a-input>
      </a-form-model-item>
      <a-form-model-item label="基础数据名称" prop="codeMapName">
        <a-input v-model="command.codeMapName" placeholder="请输入基础数据名称" :maxLength="20"></a-input>
      </a-form-model-item>
      <a-form-model-item label="基础数据类型" prop="codeType">
        <a-select v-model="command.codeType" placeholder="请选择基础数据类型" :options="codeTypeList"></a-select>
      </a-form-model-item>
      <a-form-model-item label="状态" prop="status">
        <a-select v-model="command.status" placeholder="请选择状态" :options="statusList"></a-select>
      </a-form-model-item>
    </a-form-model>
  </a-modal>
</template>

<script>
import { addCodeMap, editCodeMap, singleCodeMap } from '@/api/codeMap';
const defaultCommand = {
  codeType: '00',
  status: '00',
}
export default {
  name: "addCodeMap",
  data() {
    return {
      visible:false,
      isEdit:false,
      codeTypeList:[{'value': '00', 'label': '人员类别'}],
      statusList:[{'value': '00', 'label': '正常'}, {'value': '99', 'label': '停用'}],
      command:{...defaultCommand},
      rules:{
        codeMapName:[{required:true,message:"请输入基础数据名称"}],
        codeType:[{required:true,message:"请选择基础数据类型"}],
        status:[{required:true,message:"请选择状态"}],
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
    show(codeMapId){
      this.isEdit = !!codeMapId;
      if(this.isEdit){
        singleCodeMap(codeMapId).then(res=>{
          this.command = res.data;
          this.visible = true;
        })
      }else{
        this.visible = true;
      }
    },
    ok(){
       this.$refs.codeMapForm.validate(success=>{
        if(success){
          let request;
          if(this.isEdit){
            request = editCodeMap(this.command.codeMapId, this.command);
          }else{
            request = addCodeMap(this.command);
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
