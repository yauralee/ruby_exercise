# Git笔记
## 三棵树
* **HEAD：** HEAD 是当前分支引用的指针，它总是指向该分支上的最 后一次提交。 这表示HEAD将是下一次提交的父结点。
* **索引：** 索引是预期的下一次提交，也即“暂存区域”。
* **工作目录：**本地工作空间。

## reset
reset可以直接操纵三棵树，做了三个基本工作：

* **移动HEAD:**  reset 做的第一件事是移动 HEAD 指向的分支。如果 HEAD 设置为 master 分支（例如，你正在 master 分支上），运行 `git reset 9e5e64a` 将会使 master 指向 `9e5e64a`。
![1](https://github.com/yauralee/my_note/raw/master/git_note/picture/1.png)
使用 `reset --soft`，将停止在这一步/。本质上是撤销了上一次 commit 命令。 当你在运行 `git commit` 时，Git 会创建一个新的提交，并移动 HEAD 所指向的分支来使其指向该提交。 当你将它 reset 回 HEAD~（HEAD 的父结点）时，其实就是把该分支移动回原来的位置，而不会改变索引和工作目录。
* **更新索引（--mixed）:**
![2](https://github.com/yauralee/my_note/raw/master/git_note/picture/2.png)
默认指定 `--mixed` 选项，reset 将会在这时停止。 所以如果没有指定任何选项（在本例中只是 git reset HEAD~），这就是命令将会停止的地方。
此步撤取消暂存所有的东西。 于是，我们回滚到了所有 git add 和 git commit 的命令执行之前。
* **更新工作目录（--hard）：**
![3](https://github.com/yauralee/my_note/raw/master/git_note/picture/3.png)
如果使用 --hard 选项，它将会继续让工作目录看起来像索引。 撤销了最后的提交、git add 和 git commit 命令以及工作目录中的所有工作。

## 找回删除的commit

![3-1](https://github.com/yauralee//my_note/raw/master/git_note/picture/3-1.png)
假设使用`git reset --hard HEAD~1`删除了commit，又想恢复, 则使用`git reflog`显示出所有的操作记录。
![3-2](https://github.com/yauralee/my_note/raw/master/git_note/picture/3-2.png)
再用`git reset --hard bc2b071`删除最近的记录，则恢复被删除的commit。


## 撤消对文件的修改
如果你并不想保留对 CONTRIBUTING.md文件的修改:

    $ git checkout -- CONTRIBUTING.md
    $ git status
      On branch master
      Changes to be committed:
      (use "git reset HEAD <file>..." to unstage)

       renamed:    README.md -> README
   可以看到那些修改已经被撤消了。
   `git checkout -- [file]`  使得对文件做的任何修改都会消失。
## 远程仓库
* **查看远程仓库:**

  运行` git remote` 命令会列出你指定的每一个远程服务器的简写。 至少应该能看到 origin - 这是 Git 给你克隆的仓库服务器的默认名字。
  
        $ git remote
          origin
      
  也可以指定选项` -v`，会显示需要读写远程仓库使用的 Git 保存的简写与其对应的 URL。
  
        $ git remote -v
          origin  https://github.com/schacon/ticgit (fetch)
          origin  https://github.com/schacon/ticgit (push)
  如果你的远程仓库不止一个，该命令会将它们全部列出。 例如，与几个协作者合作的，拥有多个远程仓库的仓库看起来像下面这样：
  
         $ git remote -v
           bakkdoor  https://github.com/bakkdoor/grit (fetch)
           cho45     https://github.com/cho45/grit (fetch)
           origin    git@github.com:mojombo/grit.git (push)
           
* **添加远程仓库:** 

  `git remote add <shortname> <url> `添加一个新的远程 Git 仓库，同时指定一个简写：
  
         $ git remote
           origin
         $ git remote add pb https://github.com/paulboone/ticgit
         $ git remote -v
           origin  https://github.com/schacon/ticgit (fetch)
           origin  https://github.com/schacon/ticgit (push)
           pb  https://github.com/paulboone/ticgit (fetch)
           pb  https://github.com/paulboone/ticgit (push)
           
* **远程仓库的移除与重命名:**

  运行` git remote rename` 修改一个远程仓库的简写名。
   例如，想要将 pb 重命名为 paul，可以用` git remote rename `这样做：
   
        $ git remote rename pb paul
        $ git remote
          origin
          paul
  这同样也会修改远程分支名字,过去引用` pb/master` 的现在会引用 `paul/master`。
 
   移除一个远程仓库,如某一个贡献者不再贡献了 - 可以使用 `git remote rm` ：
   
        $ git remote rm paul
        $ git remote
          origin
          
## 将代码传到多个远端仓库
编辑本地仓库的`.git/config`文件：

    [remote "all"]
       url = git@github.com:foo/bar.git
       url = git@gitcafe.com:hello/world.git
   推送命令：
   
     $ git push all
     
## revert撤销一个“已公开”的改变
场景: 已经执行了 `git push`, 现在发现这些 commit 的其中一个是有问题的，需要撤销那一个 commit.

方法: `git revert <SHA>`

原理:` git revert `会产生一个新的 commit，它和指定 SHA 对应的 commit 是相反的（或者说是反转的）。任何从原先的 commit 里删除的内容会在新的 commit 里被加回去，任何在原先的 commit 里加入的内容会在新的 commit  里被删除。并不会改变历史 — 所以可以 `git push` 新的“反转” commit 来抵消你错误提交的 commit。

## gitignore 
已经track或者已经push后如何ignore?

1. .gitignore针对的是未追踪的文件，当文件已经被追踪后想要         ignore, 只能先从更改追踪状态，即从 Git 的数据库中删除对于该文件的追踪（git rm —cached  file）, 这时stage区的文件被删除，workspace区仍然存在；
2. 再把对应的规则写入 .gitignore，让忽略真正生效；
3. 提交＋推送

## 删除分支
    $ git branch -d [name]
   `-d`选项只能删除已经参与了合并的分支，对于未有合并的分支是无法删除的。如果想强制删除一个分支，可以使用`-D`选项。
   
## fork后怎么更新

1. 检出自己在github上fork别人的分支到rrest目录下，其中rrest目录之前是不存在的。

        $ git clone git@github.com:yss/rrestjs.git rrest
2. 然后增加远程分支（也就是你fork那个人的分支）名为bob（这个名字任意）到你本地。

        $ git remote add bob https://github.com/DoubleSpout/rrestjs.git
        
  如果运行命令：`git remote -v`会多出来了一个Bob的远程分支。如下：
  
        bob https://github.com/DoubleSpout/rrestjs.git (fetch)
        bob https://github.com/DoubleSpout/rrestjs.git (push)
        origin git@github.com:yss/rrestjs.git (fetch)
        origin git@github.com:yss/rrestjs.git (push)
      
3. 然后，把对方的代码拉到自己本地。
    
        $ git fetch bob
4. 最后合并对方的代码并push。

        $ git merge bob/master
        $ git push origin master
        
## rebase
Git 中整合来自不同分支的修改主要有两种方法：merge 以及 rebase 

* **rebase的基本操作**

假设开发任务分叉到两个不同分支，又各自提交了更新。
![4](https://github.com/yauralee/my_note/raw/master/git_note/picture/4.png)
整合分支最容易的方法是 merge 命令。 会把两个分支的最新快照（C3 和 C4）以及二者最近的共同祖先（C2）进行三方合并，合并的结果是生成一个新的快照（并提交）。
![5](https://github.com/yauralee/my_note/raw/master/git_note/picture/5.png)
还有一种方法：提取在 C4 中引入的补丁和修改，然后在 C3 的基础上再应用一次。即rebase(变基)。运行：

     $ git checkout experiment
     $ git rebase master
     First, rewinding head to replay your work on top     of it...
    Applying: added staged command
它的原理是首先找到这两个分支（即当前分支 experiment、rebase操作的目标基底分支 master）的最近共同祖先 C2，然后对比当前分支相对于该祖先的历次提交，提取相应的修改并存为临时文件，然后将当前分支指向目标基底 C3, 最后以此将之前另存为临时文件的修改依序应用。
![6](https://github.com/yauralee/my_note/raw/master/git_note/picture/6.png)
再回到 master 分支，进行一次快进合并。

    $ git checkout master
    $ git merge experiment
![7](https://github.com/yauralee/my_note/raw/master/git_note/picture/7.png)

* **使用情况**

  这两种整合方法的最终结果没有任何区别，只不过提交历史不同，rebase是将一系列提交按照原有次序依次应用到另一分支上，而merge是把最终结果合在一起。

  rebase使得提交历史更加整洁。 在查看一个经过变基的分支的历史记录时会发现，看上去就像是先后串行的一样，提交历史是一条直线没有分叉。

  一般使用rebase的目的是为了确保在向远程分支推送时能保持提交历史的整洁——例如向某个别人维护的项目贡献代码时。 在这种情况下，你首先在自己的分支里进行开发，当开发完成时你需要先将你的代码rebase到 `origin/master` 上，然后再向主项目提交修改。 使得该项目的维护者就不再需要进行整合工作，只需要快进合并便可。

* **rebase实例**

  在对两个分支进行变基时，如下图创建一个分支 server，为服务端添加了一些功能，提交了 C3 和 C4。 然后从 C3 上创建了特性分支 client，为客户端添加了一些功能，提交了 C8 和 C9。 最后，你回到 server 分支，又提交了 C10。
 ![8](https://github.com/yauralee/my_note/raw/master/git_note/picture/8.png)
  假设你希望将 client 中的修改合并到主分支并发布，但暂时并不想合并 server 中的修改（它们还需要经过更全面的测试）。 这时可以使用 `git rebase` 命令的 `--onto` 选项，选中在 client 分支里但不在 server 分支里的修改（即 C8 和 C9），将它们在 master 分支上重演：

         $ git rebase --onto master server client
![9](https://github.com/yauralee/my_note/raw/master/git_note/picture/9.png)
快进合并 master 分支了：

         $ git checkout master
         $ git merge client
![10](https://github.com/yauralee/my_note/raw/master/git_note/picture/10.png)
接下来决定将 server 分支中的修改也整合进来。 使用 `git rebase [basebranch] [topicbranch] `命令可以直接将特性分支（即本例中的 server）rebase到目标分支（即 master）上。这样做能省去你先切换到 server 分支，再对其执行rebase命令的多个步骤。

         $ git rebase master server
如图 ，server 中的代码被“续”到了 master 后面。
![11](https://github.com/yauralee/my_note/raw/master/git_note/picture/11.png)
然后快进合并主分支 master ：

         $ git checkout master
         $ git merge server
至此，client 和 server 分支中的修改都已经整合到主分支里去了，可以删除这两个分支，最终提交历史会变成图 中的样子：

         $ git branch -d client
         $ git branch -d server
         
![12](https://github.com/yauralee/my_note/raw/master/git_note/picture/12.png)

* **rebase风险**

   **不要对在你的仓库外有副本的分支执行变基**

   如果你已经将提交推送至某个仓库，而其他人也已经从该仓库拉取提交并进行了后续工作，此时，如果你用` git rebase` 命令重新整理了提交并再次推送。
 
 假设你从一个中央服务器克隆然后在它的基础上进行了一些开发。 你的提交历史如图所示：
![13](https://github.com/yauralee/my_note/raw/master/git_note/picture/13.png)

 然后，某人又向中央服务器提交了一些修改，其中还包括一次merge。 你抓取了这些在远程分支上的修改，并将其合并到你本地的开发分支，然后你的提交历史就会变成这样：
 ![14](https://github.com/yauralee/my_note/raw/master/git_note/picture/14.png)

接下来，这个人又决定把merger操作回滚，改用rebase；继而又用 `git push --force `命令覆盖了服务器上的提交历史。 之后你从服务器抓取更新，会发现多出来一些新的提交。
 ![15](https://github.com/yauralee/my_note/raw/master/git_note/picture/15.png)
 
 结果就是你们两人的处境都十分尴尬。 如果你执行 `git pull` 命令，你将合并来自两条提交历史的内容，生成一个新的merge提交，最终仓库会如图所示：
  ![16](https://github.com/yauralee/my_note/raw/master/git_note/picture/16.png)
  
  此时如果你执行` git log `命令，会发现有两个提交的作者、日期、日志是一样的。此外，如果你将这一堆又推送到服务器上，你实际上是将那些已经被rebase抛弃的提交又找了回来。 很明显对方并不想在提交历史中看到 C4 和 C6，因为之前就是他们把这两个提交通过rebase丢弃的。
  
## 用rebase解决rebase
如果遭遇了类似的处境，团队中的某人强制推送并覆盖了一些你所基于的提交，一种简单的方法是使用 `git pull --rebase` 命令而不是直接 `git pull`。 又或者你可以自己手动完成这个过程，先 `git fetch`，再 `git rebase teamone/master`。
  ![17](https://github.com/yauralee/my_note/raw/master/git_note/picture/17.png)
  
  _如果习惯使用 git pull ，同时又希望默认使用选项 --rebase，可以执行这条语句 git config --global pull.rebase true 来更改 pull.rebase 的默认配置。_

_只要你把变基命令当作是在推送前清理提交使之整洁的工具，并且只在从未推送至共用仓库的提交上执行变基命令，你就不会有事。 假如你在那些已经被推送至共用仓库的提交上执行变基命令，并因此丢弃了一些别人的开发所基于的提交，你的同事也会因此鄙视你。
如果某些情形下决意要这么做，请一定执行 git pull --rebase 命令，这样尽管不能避免伤痛，但能有所缓解。_





