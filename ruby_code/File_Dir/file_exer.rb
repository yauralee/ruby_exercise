require "fileutils"
require 'etc'
require 'find'

class FileExer
  #File.rename(before,after)
  File.rename("a.rb", "b.rb")
  File.rename("for_remove.yml","after/for_remove.yml")

  #Fileutils.cp  Fileutils.mv
  FileUtils.cp("b.rb", "after/b.rb")
  FileUtils.mv("b.rb", "after/b.rb")
  FileUtils.mv("file_exer.rb", "after/file_exer.rb")
  FileUtils.mv("file_exer.rb", "../file_exer.rb")

  #File.delete(file)  File.unlink(file)
  File.delete("after/for_delete.rb")

  #Dir.pwd   Dir.chdir(dir)
  p Dir.pwd
  Dir.chdir("after/subdir")
  p Dir.pwd
  io = File.open("for_open.rb")
  io = File.open("git_note.md")
  p Dir.pwd
  Dir.chdir("/Users/yuli/Documents")
  p Dir.pwd
  io = File.open("help.md")
  # p io
  io.close

  #Dir.open(path)  Dir.close
  dir = Dir.open("/Users/yuli/Documents")
  while name = dir.read
    p name
  end
  dir.close

  dir.each do |name|
    p name
  end
  dir.close

  Dir.open("/Users/yuli/Documents") do |dir|
    dir.each do |name|
      p name
    end
  end

  #dir.read
  def self.traverse(path)
    if File.directory?(path)
      dir = Dir.open(path)
      while name = dir.read
        next if name == "."
        next if name == ".."
        traverse(path + "/" + name)
      end
      dir.close
    else
      process_file(path)
    end
  end

  def self.process_file(path)
    puts path
  end

  traverse("/Users/yuli/Documents")

  #Dir.glob
  Dir.chdir("after")
  p Dir.pwd
  p Dir.glob("*")  #以数组形式返回["b.rb", "for_remove.yml", "subdir"]
  p Dir.glob(".*") #获取隐藏的文件名[".", "..", ".hide.rb"]
  p Dir.glob(%w(*.html *htm))
  p Dir.glob("**/*")

  #Dir.mkdir(path)  Dir.rmdir(path)
  # Dir.mkdir("temp")
  # Dir.rmdir("temp")

  #File.stat(path) 获取文件、目录的属性,返回File::Stat类实例
  #用uid和gid获取用户ID和组ID时,需要require Etc 模块
  st = File.stat("/Users/yuli/Documents")
  pw = Etc.getpwuid(st.uid)
  p pw.name     #yuli
  gr = Etc.getgrgid(st.gid)
  p gr.name     #staff

  # p File.ctime("/Users/yuli/Documents/help.md")

  File.utime(atime, mtime, path)
  filename = "foo"
  File.open(filename,"w").close

  st = File.stat(filename)
  p st.atime       #最后访问时间
  p st.mtime       #最后修改时间
  p st.ctime       #文件状态的最后更改时间

  File.utime(Time.now-100*24*24*30, Time.now-100, filename)   #改变时间以秒为单位
  st = File.stat(filename)
  p st.atime       #最后访问时间
  p st.mtime       #最后修改时间
  p st.ctimetime       #文件状态的最后更改时间

  #File.chmod(mode, path)  修改访问权限 mode为整数,表示新的访问权限值
=begin
chmod
chmod是Linux下设置文件权限的命令，后面的数字表示不同的用户或用户组的权限。
一般是三个数字：
第一个数字表示文件所有者的权限
第二个数字表示与文件所有者同属一个用户组的其他用户的权限
第三个数字表示其它用户组的权限
权限分三种：
读 r=4
写 w=2
执行 x=1
综合起来：
rx=5 rw=6 rwx=7
所以chmod 755表示用户对该文件拥有读，写，执行的权限，
同组其他人员拥有执行和读的权限，没有写的权限，其他用户的权限和同组人员权限一样.
=end
  File.chmod(0755, "foo")
  # #追加写权限
  rb_file = "foo"
  st = File.stat(rb_file)
  File.chmod(st.mode | 0111, rb_file)


  #FileTest模块

  #文件名的操作

  #File.basename(path[,suffix])返回path中最后一个/之后的部分,如果指定了扩展suffix,则去除扩展名,用于从路径中获取文件名
  p File.basename("/Users/yuli/Documents/foo")  #foo
  p File.basename("/Users/yuli/Documents/help.md", ".md")  #help
  p File.basename("help.md")  #help.md

  #File.dirname(path) 返回path中最后一个/之前的内容,路径不包含/时返回.  用于从路径中获取目录名
  p File.dirname("/Users/yuli/Documents/help.md")  #/Users/yuli/Documents
  p File.dirname("Users")  #.
  p File.dirname("/")  #/

  #File.extname(path) 返回basename方法返回结果中的扩展名,没有扩展名或以.开头的文件名则返回空字符串
  p File.extname("help.md")
  p File.extname("foo")
  p File.extname("~/.gz")

  #File.split(path)将path分为目录与文件名两部分,以数组形式返回
  p File.split("/Users/yuli/Documents/help.md")

  #File.join(name1[,name2,...]) 将参数连接成path
  p File.join("/Users/yuli/Documents/", "help.md")

  #File.expand_path(path[,default_dir])根据目录名default_dir将相对路径path转为绝对路径
  Dir.chdir("/Users/yuli/Documents")
  p Dir.pwd  #"/Users/yuli/Documents"
  p File.expand_path("bin")  #"/Users/yuli/Documents/bin"
  p File.expand_path("../bin")  #"/Users/yuli/bin"
  p File.expand_path("../etc", "/user")  #"/etc"

  #与操作文件相关的库

  #find库  find库中find模块用于对指定目录下的目录或文件做递归处理
  #Find.find(dir){|path|...}将目录dir下的所有文件路径依次传给path
  #Find.prune 使用Find.find方法时,调用Find.prune方法后,程序会跳过当前查找目录下的所有路径
  #需要require 'find'
  IGNORE = [/^for_prune$/,/^for_prune2$/]
  def self.listdir(top)
    Find.find(top) do |path|
      if FileTest.directory?(path)
        dir, base = File.split(path)
        IGNORE.each do |ignore|
          if ignore =~ base
            Find.prune
          end
        end
        puts path
      end
    end
  end

  p Dir.pwd  #"/Users/yuli/RubymineProjects/project_exercise/ruby_exercise/ruby_code/File_Dir"
  listdir("/Users/yuli/RubymineProjects/project_exercise/ruby_exercise/ruby_code/File_Dir")


  #tempfile库: 用于管理临时文件
  #Tempfile.new(basename[,tempdir])创建临时文件,实际生成文件名为"basename+进程ID+流水号"
  p Tempfile.new("atemp").path  #"/var/folders/8k/x63br20d3p5cyr7tn117y2br0000gn/T/atemp20160702-1130-ib0ftl"

  #fileutils库
  #FileUtils.cp(from, to)把文件从from拷贝到to


end