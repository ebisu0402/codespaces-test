class Game
  def initialize
    puts "↓勇者の名前を入力してください↓"
    hero_name = gets.chomp  

    @heroes = create_heroes(hero_name)
    @monsters = create_monsters
    @escape_flg = false

    @heroes.each do |hero|
      display_character_info(hero)
    end

    @monsters.each do |monster|
      display_character_info(monster)
    end
    
  end

  def create_heroes(hero_name)
    [
      Character.new(hero_name, 30, 6, Constants::ATTACK_TYPE_NORMAL, true), 
      Character.new("魔法使い", 20, 8, Constants::ATTACK_TYPE_MAGIC) 
    ]
  end

  def create_monsters
    [
      Character.new('オーク', 30, 8, Constants::ATTACK_TYPE_NORMAL),
      Character.new('ゴブリン', 25, 6, Constants::ATTACK_TYPE_NORMAL)  
    ]
  end

  def display_character_info(character)
    puts "\nキャラクター名：#{character.name}"
    puts "HP：#{character.hp}"
    puts "こうげき力：#{character.attack_damage}"
    puts "こうげきタイプ：#{character.attack_type}"
    puts "プレイヤーフラグ：#{character.is_player}"
    puts "生存フラグ：#{character.is_alive}"
  end
  
  def display_status(character)
    puts "・【#{character.name}】 HP：#{character.hp} こうげき力：#{character.attack_damage}"
  end


def process_heroes_turn
    @heroes.each do |character|    #　@heroesの各オブジェクトを呼び出す
      next unless character.is_alive    # is_aliveがfalseなら以下の処理を行わない
      loop do
        # 行動選択
        if character.is_player
          # プレイヤー（勇者）のとき
          puts "\n↓行動を選択してください↓"
          puts "【#{Constants::ACTION_ATTACK}】こうげき"
          puts "【#{Constants::ACTION_ESCAPE}】逃げる"

          choice = gets.to_i  # 行動の入力を整数で受け付ける
        else
          # それ以外のとき
          choice = Constants::ACTION_ATTACK # デフォルトの選択
        end

        # 行動
        case choice
        when Constants::ACTION_ATTACK
          # こうげき
          target_character = @monsters.select(&:is_alive).sample            # 対象を絞る
          execute_attack(character, target_character) if target_character   # こうげき処理
          break   # ループを抜ける
        when Constants::ACTION_ESCAPE
          # 逃げる
          execute_escape(character)   # 逃げる処理
          return  # メソッドを抜ける
        else
          # 無効な選択
          puts "無効な選択肢です"
        end
      end
    end
  end 
  def process_monsters_turn
    @monsters.each do |monster|
      target_hero = nil
      @heroes.each do |hero|
        if hero.is_alive
          target_hero = hero
            break
          end
        end

        if target_hero
          execute_attack(monster, target_hero)
        end
      end
end
  def party_destroyed?(party)
    party.all? { |member| !member.is_alive }
  end



  def execute_attack(attacker, defender)
    case attacker.attack_type
    when Constants::ATTACK_TYPE_NORMAL
      puts "#{attacker.name}のこうげき!!"
      sleep(0.5)
    when Constants::ATTACK_TYPE_MAGIC
      puts "#{attacker.name}の魔法こうげき!!"
      sleep(0.5)
    end

    damage = attacker.calculate_damage()
    defender.receive_damage(damage)

    puts "#{defender.name}に#{damage}のダメージ!!"
    sleep(0.3)
    puts "#{defender.name}はたおれた!" unless defender.is_alive
    sleep(0.3)

  end 

  def execute_escape(character)
    puts"#{character.name}は逃げ出した"
    @escape_flg = true
  end


  def start
    round = 0
    puts"\n◆◆◆ モンスターが現れた!! ◆◆◆"

    loop do
      round += 1
      puts"\n=== ラウンド #{round} ==="

    @heroes.each { |character| display_status(character) }  
    @monsters.each { |character| display_status(character) } 
      
    process_heroes_turn()
    return if @escape_flg

    break if party_destroyed?(@heroes) || party_destroyed?(@monsters)

    process_monsters_turn
    break if party_destroyed?(@heroes) || party_destroyed?(@monsters)
  end
  if party_destroyed?(@monsters)
    puts "勇者パーティの勝利!!"
  elsif party_destroyed?(@heroes)
    puts "勇者達は力尽きた…"
  end

  puts "◆◆◆ GAME OVER...◆◆◆"
end
end



class Character
    attr_accessor :name, :hp, :attack_damage, :attack_type, :is_player, :is_alive

    def initialize(name, hp, attack_damage, attack_type, is_player = false)
        @name = name
        @hp = hp
        @attack_damage = attack_damage
        @attack_type = attack_type
        @is_player = is_player
        @is_alive = true
    end

    def calculate_damage
      rand(@attack_damage - Constants::ATTACK_VARIANCE..@attack_damage + Constants::ATTACK_VARIANCE)
    end
    
    def receive_damage(damage)
      @hp -= damage
      if @hp <= Constants::HP_MIN
        @hp = Constants::HP_MIN
        @is_alive = false
        end
        
    end
end

  class Constants
    ATTACK_TYPE_NORMAL = 1
    ATTACK_TYPE_MAGIC = 2
    ATTACK_VARIANCE = 3
    HP_MIN = 0
    ACTION_ATTACK = 1
    ACTION_ESCAPE = 2
end



game = Game.new
game.start()