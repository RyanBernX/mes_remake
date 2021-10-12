#==============================================================================
# 本脚本来自[url]https://rpg.blue[/url]，使用和转载请保留此信息
#------------------------------------------------------------------------------
# 原版：趙雲
# 重制：RyanBern  2015.08.24
#------------------------------------------------------------------------------
# 更新记录：
#     2015.09.06    少许BUG修复，附加战斗场景对话效果
#     2015.11.05    修复临时更改字号功能
#     2015.11.13    增加更改姓名颜色的功能，修复显示 BUG
#     2016.01.19    增加大型半身像对话框设置，快捷方式设置，高级快捷方式设置
#     2016.05.10    增加对话框开关，打开指定开关时暂时屏蔽本对话加强窗口
#                   增加\f[头像]的功能，可以显示正方形的说话者头像
#     2016.08.26    简化代码，增加自动对话功能，高速跳过对话功能
#     2016.11.05    增加自动调节文字位置的功能，当对话框太靠近屏幕上方或者下方
#                   时，脚本会更换成另外一个显示的方向。
#     2017.01.11    增加连行功能和兼容 VA 的头像组功能
#     2021.10.12    修复淡入淡出不正常的 BUG
#                   数值输入对话框现在会在打字结束后显示（而不是一开始就显示出来）
#                   \> 和 \< 的功能可以使用了
#                   增加一个开关，控制对话框淡入淡出效果
#============================================================================== 
 
#——说明
 
# 使用时，要在Graphics文件夹下新建一个名为Faces的文件夹，用于存储头像
# 对话框的窗口素材可不必和系统窗口相同，请将对话框窗口素材放到
# Graphics/Windowskins文件夹下，并附上两个气泡箭头素材，用于指向说话者，
# 命名规则为“对话框窗口素材名-top”和“对话框窗口素材名-under”
# 然后在本脚本的设置区域修改。
 
# 默认为一个字一个字的方式，如果需要一次全部显示，
# 请打开特定开关（默认为 21 号）

# 打开开关（默认为 22 号）后，对话时按下[空格键]可以瞬间显示全部对话。

# 打卡开关（默认为 23 号）后，屏蔽加强对话框，将使用 XP 默认对话框。

# 打开开关（默认为 24 号）后，对话框可以在对话显示完毕后自动消失，适合制作
# 场景 CG，需要进行选择或数字输入的情况不会自动消失。此外在文本框中使用\t[数字]
# 也可达到相似效果，不过作用范围仅限本次对话框。

# 打开开关（默认为 25 号）后，按下 CTRL 键可以快速跳过对话，需要进行选择或者数字
# 输入的情况不会跳过。

# 打开开关（默认为 26 号）后，对话框的位置会自动调节，使其不会遮挡说话者

# 打开开关（默认为 27 号）后，对话框显示和消失时将不会有淡入淡出效果。

# 默认对话字没有声音，如果需要声音，
# 请在游戏中使用脚本：$game_system.soundname_on_speak = "这里输入文件名"
# 我唯一一个见过“胡乱配音”的游戏是天使帝国2代，该游戏说话的时候每个字符随机发一个外星语音

#------------------------------------------------------------------------------
 
# 其他在对话中可以使用的功能（部分功能在关闭打字效果时无效）：
 
# \n[1]：显示1号角色的姓名
 
# \name[李逍遥]：显示一个“李逍遥”方框，表示说话人姓名
# \nc[0-7]：更改姓名框颜色
 
# 非战斗时，\p功能可以自动调整对话框位置
# \p[1] ：对话框出现在1号事件的上方
# \p[0] ：主人公上方出现对话框
# \p[-1]：对话框出现在屏幕下方，这种特殊类型的对话框在有大型半身像时使用
#——————————————————使用\p功能后可以自动调整对话框大小
# 使用\p功能后，使用事件指令[更改文章选项]可更改对话框的位置
#   [上] ：对话框出现在说话者上方
#   [下] ：对话框出现在说话者下方
#   [中] ：对话框出现在屏幕正中
# 战斗时，\p功能有所变化
# \p[1]：对话框出现在ID为1的角色战斗图附近（这个角色必须是队伍中的成员）
# \p[1001]：对话框出现在Index为1的敌人战斗图附近--也就是说敌人的位置从
#           1001开始算起，1002则是代表Index为2的敌人。
# 战斗时使用\p指令+[更改文章选项]依然是有效的，但是如果不使用\p指令，那么
# 对话框则会一直出现在屏幕正上方。
 
# \\：显示"\"这个符号
 
# \v[1] ：显示变量1
 
# \v[a1] ：显示防具1
 
# \v[w1] ：显示武器1
 
# \v[i1] ：显示物品1
 
# \v[s1] ：显示特技1
 
# \ic[001-Weapon01] : 显示图标"001-Weapon01.png"
 
# \c[0-7]：更改颜色
 
# \g：显示金钱窗口
 
# \a[SE文件名]：对话的时候播放SE
 
# \s[0-19]：更改弹字的速度，数值越小描绘越快（超过 19 时设置无效）
 
# \.   ：停顿一刹那（5帧，不包含描绘时的自然停顿）
# \|   ：停顿片刻（20帧，不包含描绘时的自然停顿）
 
# \>   ：文字不用打字方式
# \<   ：文字使用打字方式
 
# \!   ：等待玩家按回车再继续
# \~   ：文字直接消失
 
# \I   ：下一行从这个位置开始
 
# \o[123]：文字透明度改为123，模拟将死之人(汗)
 
# \h[12]：改用12号字
 
# \b[50]：空50象素

# \t[20]：对话显示完毕后等待 20 帧自动消失
 
# \L[001]：在左边显示半身像"Graphics/Faces/001.png"，并左右镜像反转
# \R[001]：在右边显示半身像"Graphics/Faces/001.png"
# \f[001]：在左边显示正方形头像"Graphics/Faces/001.png"
# 注：不推荐同时使用显示半身像的功能和显示头像的功能。显示的头像图片大小
#     不得超过 120x120，如果图片超过这个大小，图片将会被放缩
# \gf[001, 0]：在左边显示正方形头像组"Graphics/Faces/001.png"的第一个
# 注：头像组排序方式默认如下（先数第一行，再数第二行，可调节每行的头像个数）
#  -----------------
#  | 0 | 1 | 2 | 3 |
#  -----------------
#  | 4 | 5 | 6 | 7 |
#  -----------------

# \+：必须放在每一行的末尾，表示连行，它将合并下一个【显示文章】指令（需要
#     在下面的设置区域调节 Max_Lines 以保证文字能正常显示出来）

#==============================================================================
# 设置区域（其他参数的调节请看这里）
#==============================================================================
module RB
end
module RB::Mes_Config
  # 打开 XX 号开关后，关闭打字效果
  No_Typing = 21
  # 打开 XX 号开关后，按下[空格键]可以瞬间显示全部文字
  Write_Skip = 22
  # 打开 XX 号开关后，屏蔽加强对话框（使用默认对话框）
  Mes_Disabled = 23
  # 主角名字字符缩写
  Regex_Player_Name = /pn(\d+)/
  # 主角姓名框底色(RGBA)
  Name_Bar_Color = Color.new(120, 180, 250, 80)
  # 字体大小
  Size = 18
  # 对话框窗口皮肤（不写为和系统皮肤相同）
  Mes_Windowskin = "001-Blue01"
  # 最大行数（初值为 4，尽量不要修改，如果考虑合并选择项和连行，可以设置为 6 以上）
  # 此最大行数仅在 \p 指令下有效，如果不使用 \p 指令那么对话框还是 4 行的高度
  Max_Lines = 8
  # 画面宽度和高度（width / height）
  # 此设置一般不需要更改，当使用分辨率扩张脚本时，将如下的值改成你游戏的分辨率即可。
  Graphics_Width = 640
  Graphics_Height = 480
  # 打开 XX 号开关后，对话自动结束（不用按下 C 键）
  Auto_Terminate = 24
  # 打开 XX 号开关后，按下 CTRL 可以高速跳过对话
  Text_Skip_Fast = 25
  # 打开 XX 号开关后，自动调节对话框使其不会挡住说话者
  Auto_Adjust_Mes_Pos = 26
  # 对话自动结束延迟（单位：帧）
  Auto_Terminate_Frame = 10
  # 打开 XX 号开关后，对话框不会有淡入淡出效果
  No_Fade = 27
  # 头像组：横向单元数
  Face_Group_W = 4
  # 头像组：纵向单元数
  Face_Group_H = 2  
  # 默认姓名文字颜色（和系统默认编号一致）
  Name_Color_Default = 6
  # 快捷指令，定义后，可以直接在文本框中输入快捷指令
  # 定义方式为 快捷指令 => 完整指令 ，使用方式为 \sc[快捷指令]
  # 注意，指令中通常包含反斜线'\'，因此需要使用单引号的字符串，
  # 或者用"\\"进行转义。下面是一个例子：
  # 这样定义后，输入\sc[pn1]就等效为 \name[pn1]\r[L1]\p[-1]
  Shortcuts = {
    #'pn1' => '\name[pn1]\r[L1]\p[-1]'
  }
  # 高级快捷指令定义，类似于宏展开，需要借助正则表达式（高级用户使用）
  Shortcuts_Regexp = {
    /\\pn1/ => '\name[pn1]\r[L1]\p[-1]',
    /\\[Rr]ed\[(.*?)\]/m => '\c[2]\1\c[0]',
    /\\[Cc]ol\[(\d+)\]\{(.*?)\}/m => '\c[\1]\2\c[0]',
  }
end
#==============================================================================
# RPG::Cache
#------------------------------------------------------------------------------
# RPG::Cache 追加定义
#==============================================================================
module RPG::Cache
  def self.face(filename)
    self.load_bitmap("Graphics/Faces/", filename)
  end
end
 
#==============================================================================
# ■ Game_System
#------------------------------------------------------------------------------
# 　处理系统附属数据的类。也可执行诸如 BGM 管理之类的功能。本类的实例请参考
# $game_system 。
#==============================================================================
 
class Game_System
  attr_accessor :soundname_on_speak
  alias carol3_ini initialize
  def initialize
    carol3_ini
    @soundname_on_speak = nil
  end
end

#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
#   修改的对话框类。
#==============================================================================
class Window_Message_RB < Window_Selectable
  include RB::Mes_Config
  # 定义经过变换后不可见的字符，描绘结束后直接描绘下一个字符，不进入下一帧
  Invisible_Chars = [
    "\001", "\003", "\n", "\023", "\024", "\025", "\076"]
  #--------------------------------------------------------------------------
  # ● 初始化状态
  #--------------------------------------------------------------------------
  def initialize
    super(80, 304, 480, 160)
    self.contents = Bitmap.new(1, 1)
    self.visible = false
    self.z = 9998
    @fade_in = false
    @fade_out = false
    @contents_showing = false
    @write_skip = false
    @text_skip = false
    @cursor_width = 0
    @face_h = 0
    self.active = false
    self.index = -1
    if $game_system.soundname_on_speak == nil then
      $game_system.soundname_on_speak = ""
    end
    self.windowskin = RPG::Cache.windowskin(Mes_Windowskin) if Mes_Windowskin != ""
    @opacity_text_buf = Bitmap.new(32, 32)
    @all_opa = 0;
  end
  #--------------------------------------------------------------------------
  # ● 释放
  #--------------------------------------------------------------------------
  def dispose
    terminate_message
    $game_temp.message_window_showing = false
    if @input_number_window != nil
      @input_number_window.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● 处理信息结束
  #--------------------------------------------------------------------------
  def terminate_message
    self.active = false
    self.pause = false
    self.index = -1
    self.contents.clear
    # 清除显示中标志
    @contents_showing = false
    # 呼叫信息调用
    if $game_temp.message_proc != nil
      $game_temp.message_proc.call
    end
    # 清除文章、选择项、输入数值的相关变量
    $game_temp.message_text = nil
    $game_temp.message_proc = nil
    $game_temp.choice_start = 99
    $game_temp.choice_max = 0
    $game_temp.choice_cancel_type = 0
    $game_temp.choice_proc = nil
    $game_temp.num_input_start = 99
    $game_temp.num_input_variable_id = 0
    $game_temp.num_input_digits_max = 0
    # 清除头像（由于是 RPG::Cache 所以无需释放）
    @face_bitmap = nil
    @face_group_bitmap = nil
    @face_ok = false
    # 清除跳过标志
    @write_skip = false
    @text_skip = false
    # 释放金钱窗口
    if @gold_window != nil
      @gold_window.dispose
      @gold_window = nil
    end
    # 释放姓名窗口
    if @name_window_text != nil
      @name_window_text.dispose
      @name_window_text = nil
    end
    # 释放右侧立绘
    if @right_picture != nil
      @right_picture.dispose
      @right_picture = nil
    end    
    # 释放左侧立绘
    if @left_picture != nil
      @left_picture.dispose
      @left_picture = nil
    end
    # 释放姓名蓝条
    if @bar != nil
      @bar.bitmap.dispose
      @bar.dispose
      @bar = nil
    end
    # 释放气泡图标
    if @k_tale != nil
      @k_tale.dispose
      @k_tale = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● 刷新
  #--------------------------------------------------------------------------
  def refresh
    # 初期化
    @x = @y = @max_x = @max_y = @indent = @lines = 0
    @face_indent = 0
    @opacity = 255
    @cursor_width = 0
    @write_speed = 0
    @write_wait = 0
    @mid_stop = false
    @popchar = -2
    @auto_terminate = -1
    if $game_temp.choice_start == 0
      @x = 8
    end
    if $game_temp.message_text != nil
      @now_text = $game_temp.message_text
      # \` 预处理
      @now_text.gsub!(/\\`/){ "\077" }
      # `foo` 预处理
      @protected = @now_text.scan(/`(.+?)`/m).flatten
      @now_text.gsub!(/`(.+?)`/m){ "\076" }
      # Shortcuts 预处理
      @now_text.gsub!(/\\sc\[(.*?)\]/) { Shortcuts[$1] || "" }
      # Shortcuts_Regexp 预处理
      Shortcuts_Regexp.each_pair do |regex, str|
        @now_text.gsub!(regex, str)
      end
      # 头像设置
      if (/\\[Ff]\[(.+?)\]/.match(@now_text)) != nil
        @face_bitmap = RPG::Cache.face($1)
        @x = @face_indent = [128, @face_bitmap.width + 4].min
        @now_text.gsub!(/\\[Ff]\[(.+?)\]/) { "" }
      end
      # 头像组设置
      if (/\\[Gg]f\[(.+?)\s*,\s*(\d+)\]/).match(@now_text) != nil
        @face_group_bitmap = RPG::Cache.face($1)
        idx = $2.to_i
        ix, iy = idx % Face_Group_W, idx / Face_Group_W
        w, h = @face_group_bitmap.width / Face_Group_W, @face_group_bitmap.height / Face_Group_H
        @face_bitmap = Bitmap.new(w, h)
        @face_bitmap.blt(0, 0, @face_group_bitmap, Rect.new(ix * w, iy * h, w, h))
        @x = @face_indent = [128, @face_bitmap.width + 4].min
        @now_text.gsub!(/\\[Gg]f\[(.+?)\s*,\s*(\d+)\]/) { "" }
      end
      #——左半身像设置
      if (/\\[Ll]\[(.+?)\]/.match(@now_text)) != nil then
        @face = $1
        if @left_picture != nil
          @left_picture.dispose
        end
        @left_picture = Sprite.new
        @left_picture.bitmap = RPG::Cache.face(@face)
        @left_picture.mirror = true
        @x = @face_indent = @left_picture.bitmap.width
        @now_text.gsub!(/\\[Ll]\[(.*?)\]/) { "" }
      end
      #——右半身像设置
      if (/\\[Rr]\[(.+?)\]/.match(@now_text)) != nil then
        @face = $1
        if @right_picture != nil
          @right_picture.dispose
        end
        @right_picture = Sprite.new
        @right_picture.bitmap = RPG::Cache.face(@face)
        @now_text.gsub!(/\\[Rr]\[(.*?)\]/) { "" }
      end
      # 显示人物姓名
      name_window_set = false
      if (/\\[Nn]ame\[(.+?)\]/.match(@now_text)) != nil
        name_window_set = true
        name_text = $1
        if Regex_Player_Name =~ name_text
          name_text = $game_actors[$1.to_i].name
        end
        @now_text.sub!(/\\[Nn]ame\[(.*?)\]/) { "" }
      end
      # 人物姓名颜色
      name_color = text_color(Name_Color_Default)
      if (/\\[Nn]c\[(\d+)\]/.match(@now_text)) != nil
        name_color = text_color($1.to_i)
        @now_text.sub!(/\\[Nn]c\[(\d+)\]/) { "" }
      end
      # 文字位置的判定
      if (/\\[Pp]\[([-1,0-9]+)\]/.match(@now_text)) != nil then
        @popchar = $1.to_i
        @now_text.gsub!(/\\[Pp]\[([-1,0-9]+)\]/) { "" }
      end
      # 自动结束判定
      @auto_terminate = Auto_Terminate_Frame if $game_switches[Auto_Terminate]
      if (/\\[Tt]\[(\d+)\]/).match(@now_text)
        @auto_terminate = $1.to_i
        @now_text.gsub!(/\\[Tt]\[(\d+)\]/) { "" }
      end
      # 开始替换文字（\v）
      begin
        last_text = @now_text.clone
        @now_text.gsub!(/\\[Vv]\[([IiWwAaSs]?)([0-9]+)\]/) { convart_value($1, $2.to_i) }
      end until @now_text == last_text
      # 替换控制码
      @now_text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
        $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
      end
      @now_text.gsub!(/\\\\/) { "\000" }
      @now_text.gsub!(/\\[Cc]\[([0-9]+)\]/) { "\001[#{$1}]" }
      @now_text.gsub!(/\\[Gg]/) { "\002" }
      @now_text.gsub!(/\\[Ss]\[([0-9]+)\]/) { "\003[#{$1}]" }
      @now_text.gsub!(/\\[Aa]\[(.*?)\]/) { "\004[#{$1}]" }
      @now_text.gsub!(/\\[.]/) { "\005" }
      @now_text.gsub!(/\\[|]/) { "\006" }
      @now_text.gsub!(/\\[Ii]c\[(.*?)\]/) { "\030[#{$1}] "}
      @now_text.gsub!(/\\[>]/) { "\016" }
      @now_text.gsub!(/\\[<]/) { "\017" }
      @now_text.gsub!(/\\[!]/) { "\020" }
      @now_text.gsub!(/\\[~]/) { "\021" }
      @now_text.gsub!(/\\[Ii]/) { "\023" }
      @now_text.gsub!(/\\[Oo]\[([0-9]+)\]/) { "\024[#{$1}]" }
      @now_text.gsub!(/\\[Hh]\[([0-9]+)\]/) { "\025[#{$1}]" }
      @now_text.gsub!(/\\[Bb]\[([0-9]+)\]/) { "\026[#{$1}]" }
      # 根据 \p 的不同设置对话框大小
      if @popchar >= 0 # \p 的情况下自动调节
        @text_save = @now_text.clone
        process_real_text
        @max_x = name_window_set ? contents.text_size(name_text).width : 0
        @max_y = Max_Lines
        for i in 0...Max_Lines
          line = @text_save.split(/\n/)[Max_Lines-i-1]
          @max_y -= 1 if line == nil && @max_y <= Max_Lines - i
          next if line == nil
          contents.font.size = Size
          cx = contents.text_size(line).width
          @max_x = cx if cx > @max_x
        end
        if @right_picture != nil && !@right_picture.disposed?
          self.width = @max_x + 48 + @face_indent + @right_picture.bitmap.width
        else
          self.width = @max_x + 48 + @face_indent
        end
        @face_h = @face_bitmap == nil ? 0 : [120, @face_bitmap.height].min
        if $game_temp.num_input_variable_id > 0
          self.height = [(@max_y - 1) * line_height + 96, @face_h + 32].max
        else
          self.height = [(@max_y - 1) * line_height + 64, @face_h + 32].max
        end
        # 生成气泡图标
        @k_tale = Sprite.new
      elsif @popchar == -1
        line_count = @now_text.split(/\n/).size
        line_count = [Max_Lines , [line_count, 4].max].min
        self.width = Graphics_Width
        self.height = [64 + line_height * (line_count - 1), @face_h + 32].max
        @max_x = self.width - 32 - @face_indent
      else
        self.width = Graphics_Width * 0.6
        self.height = 64 + line_height * 3
        @max_x = self.width - 32 - @face_indent
      end
      # 如果设置了姓名框
      if name_window_set
        off_x = 0
        off_y = -40
        space = 2
        x = self.x + off_x - space / 2
        y = self.y + off_y - space / 2
        w = self.contents.text_size(name_text).width + 26 + space
        h = 40 + space
        x = self.x + off_x + 4
        y = self.y + off_y
        @name_window_text = Air_Text.new(self.x + @face_indent+4+8, self.y+16, name_text, name_color)
        @name_window_text.z = self.z + 2
        @bar = Sprite.new
        @bar.bitmap = Bitmap.new(self.width, 24)
        face_cut = @face_bitmap == nil ? 0 : @face_indent + 2
        @bar.x = self.x + 8 + face_cut
        @bar.y = self.y + 16
        @bar.z = self.z + 2
        @bar.bitmap.fill_rect(0,0,self.width-16-face_cut,24, Name_Bar_Color)
      end
      # 一切设置完毕后，创建 contents
      if self.contents != nil
        self.contents.dispose
        self.contents = nil
      end
      self.contents = Bitmap.new(width - 32, height - 32)
      self.contents.font.color = normal_color
      self.contents.font.size = Size
    end
    # 如果选择项被设置
    if $game_temp.choice_max > 0
      @item_max = $game_temp.choice_max
      self.active = true
      self.index = 0
    end
    # 如果数值输入被设置
    if $game_temp.num_input_variable_id > 0
      digits_max = $game_temp.num_input_digits_max
      number = $game_variables[$game_temp.num_input_variable_id]
      @input_number_window = Window_InputNumber.new(digits_max)
      @input_number_window.number = number
      @input_number_window.visible = false
    end
    # 设置背景不透明度
    self.back_opacity = 200
    # 更新窗口位置
    update_window_pos
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    # 使用默认窗口外观的情况下，如果窗口的外关被变更了、再设置
    if $game_system.windowskin_name != @windowskin_name && Mes_Windowskin == ""
      @windowskin_name = $game_system.windowskin_name
      self.windowskin = RPG::Cache.windowskin(@windowskin_name)
    end
    # 地图中实时更新位置
    if @k_tale != nil && @k_tale.visible && !$game_temp.in_battle
      update_window_pos
    end
    # [空格键]跳过描绘
    if $game_switches[Write_Skip] && Input.trigger?(Input::C)
      @write_skip = true
    end
    # CTRL 高速跳过对话
    if $game_switches[Text_Skip_Fast] && Input.trigger?(Input::CTRL)
      # 选择项或数字输入时无法高速跳过
      if $game_temp.choice_max > 0 || @input_number_window != nil
        @write_skip = true
      else
        @text_skip = true
      end
    end
    # 描绘头像
    if @face_bitmap != nil && !@face_ok
      face_real_w = [120, @face_bitmap.width].min
      face_real_h = [120, @face_bitmap.height].min
      self.contents.stretch_blt(Rect.new(0, 0, face_real_w, face_real_h), @face_bitmap, Rect.new(0, 0, @face_bitmap.width, @face_bitmap.height))
      @face_ok = true
    end
    # 淡入中的情况下
    if @fade_in
      self.all_opa += 64
      if self.all_opa >= 255
        @fade_in = false
      end
      return
    end
    @now_text = nil if @now_text == "" 
    # 逐个描绘文字
    if @now_text != nil && @mid_stop == false && !@text_skip
      @write_wait = 0 if @write_skip
      if @write_wait > 0
        @write_wait -= 1
        return
      end
      tmp_text_skip = false
      while true
        @max_x = @x if @max_x < @x
        @max_y = @y if @max_y < @y
        # 处理字符
        if (c = @now_text.slice!(/./m)) != nil
          is_c_invisible = Invisible_Chars.include?(c)
          # \\的情况下
          if c == "\000"
            c = "\\"
          end
          # \c的情况下
          if c == "\001"
            @now_text.sub!(/\[([0-9]+)\]/, "")
            color = $1.to_i
            if color >= 0 and color <= 7
              self.contents.font.color = text_color(color)
            end
            c = ""
          end
          # \g的情况下
          if c == "\002"
            if @gold_window == nil && @popchar <= 0
              @gold_window = Window_Gold.new
              @gold_window.x = 560 - @gold_window.width
              if $game_temp.in_battle
                @gold_window.y = 192
              else
                @gold_window.y = self.y >= 128 ? 32 : 384
              end
              @gold_window.opacity = self.opacity
              @gold_window.back_opacity = self.back_opacity
            end
            c = ""
          end
          # \s的情况下
          if c == "\003"
            @now_text.sub!(/\[([0-9]+)\]/, "")
            speed = $1.to_i
            if speed >= 0 and speed <= 19
              @write_speed = speed
            end
            c = ""
          end
          # \a的情况下
          if c == "\004"
            @now_text.sub!(/\[(.*?)\]/, "")
            se_filename = "Audio/SE/#{$1}"
            if FileTest.exist?(se_filename)
              Audio.se_play(se_filename)
            end
            c = ""
          end
          # \.的情况下
          if c == "\005"
            @write_wait += 5
            c = ""
          end
          # \|的情况下
          if c == "\006"
            @write_wait += 20
            c = ""
          end
          # \>的情况下
          if c == "\016"
            tmp_text_skip = true
            c = ""
          end
          # \<的情况下
          if c == "\017"
            tmp_text_skip = false
            c = ""
          end
          # \!的情况下
          if c == "\020"
            # 当有其他跳过绘制功能的输入时，\! 无效
            @mid_stop = true if !@write_skip
            c = ""
          end
          # \~的情况下
          if c == "\021"
            terminate_message
            return
          end
          # \i的情况下
          if c == "\023"
            @indent = @x
            c = ""
          end
          # \o的情况下
          if c == "\024"
            @now_text.sub!(/\[([0-9]+)\]/, "")
            @opacity = $1.to_i
            c = ""
          end
          # \h的情况下
          if c == "\025"
            @now_text.sub!(/\[([0-9]+)\]/, "")
            self.contents.font.size = [[$1.to_i, 6].max, 32].min
            c = ""
          end
          # \b的情况下
          if c == "\026"
            @now_text.sub!(/\[([0-9]+)\]/, "")
            @x += $1.to_i
            c = ""
          end
          # 图标的情况
          if c == "\030"
            @now_text.sub!(/\[(.*?)\]/, "")
            self.contents.blt(@x , @y * line_height + (line_height - 24) / 2, RPG::Cache.icon($1), Rect.new(0, 0, 24, 24))
            if $game_system.soundname_on_speak != ""
              Audio.se_play($game_system.soundname_on_speak)
            end
            @x += 24
            c = ""
          end
          # 另起一行的情况下
          if c == "\n"
            if @lines >= $game_temp.choice_start
              @cursor_width = [@cursor_width, @max_x - @face_indent].max
            end
            @lines += 1
            @y += 1
            @x = 0 + @indent + @face_indent
            if @lines >= $game_temp.choice_start
              @x = 8 + @indent + @face_indent
            end
            c = ""
          end
          # \` 的情况下
          if c == "\077"
            c = "`"
          end
          # `foo` 的情况下
          if c == "\076"
            @now_text = @protected.shift + @now_text
            c = ""
          end
          if c != ""
            # 文字描画
            @x += opacity_draw_text(self.contents, @x, @y * line_height + (line_height - self.contents.font.size) / 2, c, @opacity)
            if $game_system.soundname_on_speak != "" then
              Audio.se_play($game_system.soundname_on_speak)
            end
          end
        else
          break
        end
        # 当 c 包含实际内容时才进行下一次绘制
        # 否则会绘制一个空字符，产生若干卡顿
        if !$game_switches[No_Typing] && !@write_skip && !is_c_invisible && !tmp_text_skip
          break
        end
      end
      @write_wait += @write_speed
      return
    end
    # 数值输入的处理
    if @input_number_window != nil
      @input_number_window.visible = true
      @input_number_window.update
      # 确认
      if Input.trigger?(Input::C)
        $game_system.se_play($data_system.decision_se)
        $game_variables[$game_temp.num_input_variable_id] =
          @input_number_window.number
        $game_map.need_refresh = true
        @input_number_window.dispose
        @input_number_window = nil
        terminate_message
      end
      return
    end
    # 跳过对话
    if @text_skip
      @now_text = nil
      terminate_message
      return
    end
    # 文章显示中的情况下
    if @contents_showing
      if $game_temp.choice_max == 0
        self.pause = true
      end
      # auto terminate
      if $game_temp.choice_max == 0 && @auto_terminate > 0
        @auto_terminate -= 1
        if @auto_terminate == 0
          terminate_message
        end
        return
      end
      # 取消
      if Input.trigger?(Input::B)
        if $game_temp.choice_max > 0 && $game_temp.choice_cancel_type > 0
          $game_system.se_play($data_system.cancel_se)
          $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
          terminate_message
        end
      end
      # 确定
      if Input.trigger?(Input::C)
        if @mid_stop
          @mid_stop = false
          return
        else
          if $game_temp.choice_max > 0
            $game_system.se_play($data_system.decision_se)
            $game_temp.choice_proc.call(self.index)
          end
          terminate_message
        end
      end
      return
    end
    if self.visible
      if $game_switches[No_Fade]
        $game_temp.message_window_showing = false
        self.visible = false
      else # 4 帧淡出
        @fade_out = true
        self.opacity -= 64
        if self.opacity == 0
          self.visible = false
          @fade_out = false
          $game_temp.message_window_showing = false
        end
      end
      return
    end
    if @fade_out == false and $game_temp.message_text != nil
      @contents_showing = true
      $game_temp.message_window_showing = true
      refresh
      Graphics.frame_reset
      self.visible = true
      if $game_switches[No_Fade]
        self.all_opa = 255
      else
        self.all_opa = 0
        @fade_in = true
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● 预览实际描绘内容（计算窗口宽用）
  #--------------------------------------------------------------------------
  #    实际对 @text_save 进行操作
  #    此方法用于去除某些控制码引起窗口过长的影响
  #--------------------------------------------------------------------------
  def process_real_text
    return if @text_save.nil?
    regex = /[\001-\006\016\017\020\021\024](\[.*?\]){0,1}/
    regex30 = /\030\[.*?\]/
    @text_save.gsub!(regex, "")
    @text_save.gsub!(regex30, "   ")
  end
  #--------------------------------------------------------------------------
  # ● 获得角色（\p功能）
  #--------------------------------------------------------------------------
  def get_character(parameter)
    case parameter
    when 0 
      return $game_player
    else 
      events = $game_map.events
      return events == nil ? nil : events[parameter]
    end
  end
  #--------------------------------------------------------------------------
  # ● 获得战斗者（\p功能，此功能仅在战斗中有效）
  #--------------------------------------------------------------------------
  #    parameter : 1-999 表示主角 ID，1001-1008 表示索引为1-8的各个敌人
  #--------------------------------------------------------------------------
  def get_battler(parameter)
    if parameter < 1000
      return $game_actors[parameter]
    else
      return $game_troop.enemies[parameter - 1001]
    end
  end
  #--------------------------------------------------------------------------
  # ● 计算 y 偏移量（\p功能，这是考虑到不同战斗图/行走图的高度不同）
  #--------------------------------------------------------------------------
  #    character : 角色/战斗者
  #--------------------------------------------------------------------------
  def process_y_shift(character)
    rate = character.is_a?(Game_Battler) ? 1 : 4
    bmp = character.is_a?(Game_Battler) ? 
      RPG::Cache.battler(character.battler_name, character.battler_hue) :
      RPG::Cache.character(character.character_name, character.character_hue)
    return bmp.height / rate + 16
  end
  #--------------------------------------------------------------------------
  # ● 更新窗口位置（所有组件）
  #--------------------------------------------------------------------------
  def update_window_pos
    # 如果使用了 \p 设置位置
    if @popchar >= 0
      character = $game_temp.in_battle ? get_battler(@popchar) : get_character(@popchar)
      final_pos = $game_system.message_position
      if character != nil
        x = [[character.screen_x - self.width / 2, 4].max, Graphics_Width - 4 - self.width].min
        # adjust final_pos automatically when it is enabled
        # ignore the case when pos == 1
        if $game_switches[Auto_Adjust_Mes_Pos] && final_pos != 1
          # try default mes_pos first
          temp_y = final_pos == 2 ? [character.screen_y + 16, 4].max :
            character.screen_y - process_y_shift(character) - self.height
          
          # set pos == 0 if temp_y exceeds the boundary of the screen
          final_pos = 0 if temp_y > Graphics_Height - 4 - self.height && final_pos == 2
          final_pos = 2 if temp_y < 4 && final_pos == 0
        end
        if final_pos == 2
          y = [[character.screen_y + 16, 4].max, Graphics_Height - 4 - self.height].min
        elsif final_pos == 0
          y = [[character.screen_y - process_y_shift(character) - self.height, 4].max, Graphics_Height - 4 - self.height].min
        else
          x = (Graphics_Width - self.width) / 2
          y = (Graphics_Height - self.height) / 2
        end
        self.x = x
        self.y = y
        # 设置气泡图标
        if @k_tale != nil
          @k_tale.x = character.is_a?(Game_Character) ?
            ( character.real_x - $game_map.display_x + 64 ) * 32 / 128 - 16 :
            character.screen_x
          k_tale_filename = Mes_Windowskin == "" ? $game_system.windowskin_name : Mes_Windowskin
          suffix = final_pos == 2 ? "-under" : "-top"
          # reload @k_tale's bitmap
          @k_tale.bitmap = RPG::Cache.windowskin(k_tale_filename + suffix)
          if final_pos == 2
            @k_tale.y = self.y - 16
          elsif final_pos == 0
            @k_tale.y = self.y + self.height - 16
          else
            @k_tale.visible = false
          end 
          @k_tale.z = 9999
        end
      end
    elsif @popchar == -1
      self.x = 0
      self.y = Graphics_Height - self.height
    else # 无 \p 的情况下
      self.x = (Graphics_Width - self.width) / 2
      # 处于战斗中时
      if $game_temp.in_battle
        self.y = 16
      else
        # 显示文章位置的分支
        case $game_system.message_position
        when 0 # 上
          self.y = 16
        when 1 # 中
          self.y = (Graphics_Height - self.height) / 2
        when 2 # 下
          self.y = (Graphics_Height - self.height - 16)
        end
      end
    end # of @popchar >= 0
    # 设置左侧立绘
    if @left_picture != nil and !@left_picture.disposed?
      @left_picture.x = self.x + 8
      @left_picture.y = self.y - @left_picture.bitmap.height + self.height - 8
      @left_picture.z = self.z + 4
    end
    # 设置右侧立绘
    if @right_picture != nil and !@right_picture.disposed?
      @right_picture.x = self.x + self.width - @right_picture.bitmap.width - 8
      @right_picture.y = self.y - @right_picture.bitmap.height + self.height - 8
      @right_picture.z = self.z + 4
    end
    # 设置姓名空气文字坐标
    if @name_window_text != nil
      @name_window_text.x = self.x + @face_indent - 4
      @name_window_text.y = self.y
    end
    # 设置姓名蓝条坐标
    if @bar != nil
      face_cut = @face_bitmap == nil ? 0 : @face_indent + 2
      @bar.x = self.x + 8 + face_cut
      @bar.y = self.y + 16
    end
    # 设置数字处理
    if @input_number_window != nil
      @input_number_window.x = self.x + @face_indent
      @input_number_window.y = self.y + 8 + $game_temp.num_input_start * line_height
    end
  end
  #--------------------------------------------------------------------------
  # ● line_height
  #--------------------------------------------------------------------------
  # 返回值 : 行高
  #--------------------------------------------------------------------------
  def line_height
    return [[Size * 15 / 10, 18].max, 32].min
  end
  #--------------------------------------------------------------------------
  # ● 文字描画
  #--------------------------------------------------------------------------
  # target ：描绘的目标 bitmap 对象
  # x      ：x 坐标
  # y      ：y 坐标
  # str　  ：描绘的文字
  # opacity：不透明度(0～255)
  # 返回值 ：文字宽度(@x 的增加值)。
  #--------------------------------------------------------------------------
  def opacity_draw_text(target, x, y, str,opacity)
    height = target.font.size
    width = target.text_size(str).width
    opacity = [[opacity, 0].max, 255].min
    if opacity == 255
      target.draw_text(x, y, width, height, str)
      return width
    else
      if @opacity_text_buf.width < width or @opacity_text_buf.height < height
        @opacity_text_buf.dispose
        @opacity_text_buf = Bitmap.new(width, height)
      else
        @opacity_text_buf.clear
      end
      @opacity_text_buf.font.size = target.font.size
      @opacity_text_buf.draw_text(0, 0, width, height, str)
      target.blt(x, y, @opacity_text_buf, Rect.new(0, 0, width, height), opacity)
    return width
    end
  end
  #--------------------------------------------------------------------------
  # ● \V 变换
  #--------------------------------------------------------------------------
  # option : 选项，'i'物品，'w'武器，'a'防具，'s'技能
  # index  : 数据库的索引
  #--------------------------------------------------------------------------
  def convart_value(option, index)
    option == nil ? option = "" : nil
    option.downcase!
    case option
      when "i"
        unless $data_items[index].name == nil
          r = sprintf("\030[%s]%s", $data_items[index].icon_name, $data_items[index].name)
        end
      when "w"
        unless $data_weapons[index].name == nil
          r = sprintf("\030[%s]%s", $data_weapons[index].icon_name, $data_weapons[index].name)
        end
      when "a"
        unless $data_armors[index].name == nil
          r = sprintf("\030[%s]%s", $data_armors[index].icon_name, $data_armors[index].name)
        end
      when "s"
        unless $data_skills[index].name == nil
          r = sprintf("\030[%s]%s", $data_skills[index].icon_name, $data_skills[index].name)
        end
      else
      r = $game_variables[index]
    end
    r == nil ? r = "" : nil
    return r
  end
  #--------------------------------------------------------------------------
  # ● 释放
  #--------------------------------------------------------------------------
  def dispose
    terminate_message
    unless @opacity_text_buf.disposed?
      @opacity_text_buf.dispose
    end
    $game_temp.message_window_showing = false
    if @input_number_window != nil
      @input_number_window.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● 刷新光标矩形
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index >= 0
      n = $game_temp.choice_start + @index
      self.cursor_rect.set(4 + @indent + @face_indent, n * line_height, @cursor_width, line_height)
    else
      self.cursor_rect.empty
    end
  end
  #--------------------------------------------------------------------------
  # ● 设置不透明度（所有组件）
  #--------------------------------------------------------------------------
  def all_opa=(opa)
    opa = [255, [opa, 0].max].min
    @all_opa = opa
    if $game_system.message_frame == 0
      self.opacity = opa
      @k_tale.opacity = opa if @k_tale
    else
      self.opacity = 0
      @k_tale.opacity = 0 if @k_tale
    end
    self.contents_opacity = opa
    @gold_window.opacity = opa if @gold_window
    @name_window_text.contents_opacity = opa if @name_window_text
    @right_picture.opacity = opa if @right_picture
    @left_picture.opacity = opa if @left_picture
    @bar.opacity = opa if @bar
  end
  #--------------------------------------------------------------------------
  # ● 获取不透明度（所有组件）
  #--------------------------------------------------------------------------
  def all_opa
    @all_opa
  end
end
#==============================================================================
# ■ Air_Text
#------------------------------------------------------------------------------
#   空气文字，借助窗口显示文字，但是不显示窗口载体。
#==============================================================================
class Air_Text < Window_Base
  #--------------------------------------------------------------------------
  # ● 对象初始化
  #--------------------------------------------------------------------------
  def initialize(x, y, designate_text, color)
    super(x-16, y-16, 32 + designate_text.size * 12, 56)
    self.opacity = 0
    self.back_opacity = 0
    self.contents = Bitmap.new(self.width - 32, self.height - 32)
    self.contents.font.size = 20
    self.contents.font.color = color
    w = self.contents.width
    h = self.contents.height
    self.contents.draw_text(0, 0, w, h, designate_text)
  end
  #--------------------------------------------------------------------------
  # ● 释放
  #--------------------------------------------------------------------------
  def dispose
    self.contents.clear
    super
  end
end
 
class Interpreter
  include RB::Mes_Config
  #--------------------------------------------------------------------------
  # ● 显示文章
  #--------------------------------------------------------------------------
  def command_101
    # 另外的文章已经设置过 message_text 的情况下
    if $game_temp.message_text != nil
      # 结束
      return false
    end
    # 设置信息结束后待机和返回调用标志
    @message_waiting = true
    $game_temp.message_proc = Proc.new { @message_waiting = false }
    # message_text 设置为 1 行
    # check whether \+ exists
    append = /\\\+$/ =~ @list[@index].parameters[0]
    line = @list[@index].parameters[0].sub(/\\\+$/, "")
    $game_temp.message_text = line + "\n"
    line_count = 1
    # 循环
    loop do
      # 下一个事件指令为文章两行以上的情况
      if @list[@index+1].code == 401 || @list[@index+1].code == 101 && append
        append = /\\\+$/ =~ @list[@index+1].parameters[0]
        line = @list[@index+1].parameters[0].sub(/\\\+$/, "")
        # message_text 添加到第 2 行以下
        $game_temp.message_text += line + "\n"
        line_count += 1
      # 事件指令不在文章两行以下的情况
      else
        # 下一个事件指令为显示选择项的情况下
        if @list[@index+1].code == 102
          # 如果选择项能收纳在画面里
          if @list[@index+1].parameters[0].size <= Max_Lines - line_count
            # 推进索引
            @index += 1
            # 设置选择项
            $game_temp.choice_start = line_count
            setup_choices(@list[@index].parameters)
          end
        # 下一个事件指令为处理输入数值的情况下
        elsif @list[@index+1].code == 103
          # 如果数值输入窗口能收纳在画面里
          if line_count < Max_Lines
            # 推进索引
            @index += 1
            # 设置输入数值
            $game_temp.num_input_start = line_count
            $game_temp.num_input_variable_id = @list[@index].parameters[0]
            $game_temp.num_input_digits_max = @list[@index].parameters[1]
          end
        end
        # 继续
        return true
      end
      # 推进索引
      @index += 1
    end
  end
end
 
class Scene_Map
  include RB::Mes_Config
  alias rb_update_20160408 update
  def update
    if @rb_mes_disabled != $game_switches[Mes_Disabled]
      @rb_mes_disabled = $game_switches[Mes_Disabled]
      @message_window.dispose if @message_window != nil
      @message_window = @rb_mes_disabled ? Window_Message.new : Window_Message_RB.new
    end
    rb_update_20160408
  end
end
 
class Scene_Battle
  include RB::Mes_Config
  alias rb_update_20160408 update
  def update
    if @rb_mes_disabled != $game_switches[Mes_Disabled]
      @rb_mes_disabled = $game_switches[Mes_Disabled]
      @message_window.dispose if @message_window != nil
      @message_window = @rb_mes_disabled ? Window_Message.new : Window_Message_RB.new
    end
    rb_update_20160408
  end
end
 
 
#==============================================================================
# 本脚本来自[url]https://rpg.blue[/url]，使用和转载请保留此信息
#==============================================================================
