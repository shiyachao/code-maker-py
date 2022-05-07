# -*- coding: UTF-8 -*-

from tkinter import *
from tkinter.ttk import *
from tkinter import messagebox
from jdbc import tl
from file import jsonFileWrite, jsonFileRead
from main import makeFile


def winCenter(win, width, height):
    # 获取屏幕尺寸以计算布局参数，使窗口居屏幕中央
    screenwidth = win.winfo_screenwidth()
    screenheight = win.winfo_screenheight()
    align = '%dx%d+%d+%d' % (width, height, (screenwidth - width) / 2, (screenheight - height) / 2)
    win.geometry(align)


class GUI:
    # 数据库连接配置
    dbConfig = {}
    # 数据库连接窗口
    formWin = {}
    # 数据库表列表窗口
    tableWin = {}
    # 表格中选中行的数据
    selected = {}

    # 数据库配置窗口
    def dbConfigView(self):
        formWin = Tk()
        self.formWin = formWin
        formWin.title("代码生成器")

        width = 300
        height = 260
        winCenter(formWin, width, height)
        group = LabelFrame(formWin, text="连接数据库")
        group.pack(fill="both", expand="yes", padx=20, pady=20, ipadx=20)
        # 表单
        Label(group, text="数据库地址：").grid(row=0, column=0, pady=5, padx=10)
        url = Entry(group)
        url.grid(row=0, column=1)
        Label(group, text="端口：").grid(row=1, column=0, pady=5, padx=10)
        port = Entry(group)
        port.grid(row=1, column=1)
        Label(group, text="数据库名：").grid(row=2, column=0, pady=5, padx=10)
        dbName = Entry(group)
        dbName.grid(row=2, column=1)
        Label(group, text="用户名：").grid(row=3, column=0, pady=5, padx=10)
        user = Entry(group)
        user.grid(row=3, column=1)
        Label(group, text="密码：").grid(row=4, column=0, pady=5, padx=10)
        pwd = Entry(group, show="*")
        pwd.grid(row=4, column=1)
        # 获取上次连接成功的值
        obj = jsonFileRead("config/db.json")
        if obj:
            url.insert(0, obj['url'])
            port.insert(0, obj['port'])
            dbName.insert(0, obj['dbName'])
            user.insert(0, obj['user'])
            pwd.insert(0, obj['pwd'])

        def setLink():
            self.linkDB(url=url.get(), dbName=dbName.get(), user=user.get(), pwd=pwd.get(), port=port.get())
            return

        Button(group, text="连接", command=setLink, width=10).grid(row=5, column=1, sticky=W)

        # 进入消息循环
        formWin.mainloop()

    # 连接数据库
    def linkDB(self, **arg):
        try:
            result = tl(**arg)
            self.formWin.destroy()
            # 连接成功，存储用户输入
            jsonFileWrite("config/db.json", arg)
            self.dbConfig = arg
            # 展示表列表
            self.tableListView(result)
        except Exception:
            messagebox.showerror("错误", "数据库连接失败！")
        return

    # 表信息数据窗口
    def tableListView(self, listArr):
        tableWin = Tk()
        self.tableWin = tableWin
        title = "{dbName}表信息".format(dbName=self.dbConfig['dbName'])
        tableWin.title(title)

        width = 630
        height = 500
        winCenter(tableWin, width, height)

        table = Treeview(tableWin, padding=0, show='headings')
        table['columns'] = ("表名", "表描述")
        table.column("表名", width=250, anchor="w")
        table.column("表描述", width=250, anchor="w")
        table.heading("表名", text="表名", anchor="w")
        table.heading("表描述", text="表描述", anchor="w")
        for i in range(len(listArr)):
            item = listArr[i]
            table.insert("", i, values=(item['tableName'], item['tableComment']))
        table.pack(side=LEFT, expand="yes", fill="y", anchor="w")

        def selectItem(a):
            curItem = table.focus()
            rowData = table.item(curItem)['values']
            self.selected = rowData

        table.bind('<ButtonRelease-1>', selectItem)

        frame = Frame(tableWin).pack(side=RIGHT, anchor="ne", padx=10)
        Button(frame, text="生成", command=self.inputApiUrl).pack(pady=5, anchor="w")
        Button(frame, text="设置", command=self.setConfig).pack(pady=5, anchor="w")
        Button(frame, text="返回", command=self.goBack).pack(pady=5, anchor="w")
        # 进入消息循环
        tableWin.mainloop()

    # 返回
    def goBack(self):
        self.tableWin.destroy()
        self.dbConfigView()

    # 填写接口请求路径
    def inputApiUrl(self):
        apiUrlView = Tk()
        apiUrlView.title("提示")
        width = 300
        height = 140
        winCenter(apiUrlView, width, height)
        group = LabelFrame(apiUrlView, text="请求路径：不填默认根据表名生成")
        group.pack(fill="both", expand="yes", padx=20, pady=20, ipadx=20)
        # 表单
        Label(group, text="路径：").grid(row=0, column=0, pady=10, padx=10)
        url = Entry(group)
        url.grid(row=0, column=1)

        def confirm():
            try:
                makeFile(apiUrl=url.get(), tableName=self.selected[0], tableComment=self.selected[1], **self.dbConfig)
                messagebox.showinfo("提示", "生成文件成功！")
            except Exception as err:
                messagebox.showerror("错误", "生成文件失败！")
            finally:
                apiUrlView.destroy()

        Button(group, text="连接", command=confirm, width=10).grid(row=4, column=1, sticky=W)
        apiUrlView.mainloop()

    # 设置窗口
    def setConfig(self):
        configView = Tk()
        configView.title("设置")
        width = 300
        height = 250
        winCenter(configView, width, height)
        group = LabelFrame(configView, text="属性")
        group.pack(fill="both", expand="yes", padx=20, pady=20, ipadx=20)
        # 表单
        Label(group, text="导出路径：").grid(row=0, column=0, pady=5, padx=10)
        outPut = Entry(group)
        outPut.grid(row=0, column=1)
        Label(group, text="公司名：").grid(row=1, column=0, pady=5, padx=10)
        comName = Entry(group)
        comName.grid(row=1, column=1)
        Label(group, text="项目名：").grid(row=2, column=0, pady=5, padx=10)
        projectName = Entry(group)
        projectName.grid(row=2, column=1)
        Label(group, text="作者：").grid(row=3, column=0, pady=5, padx=10)
        author = Entry(group)
        author.grid(row=3, column=1)
        Label(group, text="联系方式：").grid(row=4, column=0, pady=5, padx=10)
        phone = Entry(group)
        phone.grid(row=4, column=1)
        # 获取设置
        obj = jsonFileRead("config/config.json")
        if obj:
            outPut.insert(0, obj['outPut'])
            comName.insert(0, obj['comName'])
            projectName.insert(0, obj['projectName'])
            author.insert(0, obj['author'])
            phone.insert(0, obj['phone'])

        def confirm():
            obj["outPut"] = outPut.get()
            obj["comName"] = comName.get()
            obj["projectName"] = projectName.get()
            obj["author"] = author.get()
            obj["phone"] = phone.get()
            jsonFileWrite("config/config.json", obj)
            configView.destroy()
            return

        Button(group, text="确认", command=confirm, width=10).grid(row=5, column=1, sticky=W)
        configView.mainloop()


GUI().dbConfigView()
