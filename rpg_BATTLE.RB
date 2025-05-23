class Game
  def initialize
    puts "↓勇者の名前を入力してください↓"
    hero_name = gets.chomp  

    @heroes = create_heroes(hero_name)
    @monsters = create_monsters
    @escape_flg = false

    display_character_info(@heroes)
    display_character_info(@monsters)
    
  end

  def create_heroes(hero_name)
    Character.new(hero_name, 30, 6, Constants::ATTACK_TYPE_NORMAL, true) 
  end

  def create_monsters
    Character.new('オーク', 30, 8, Constants::ATTACK_TYPE_NORMAL)  
  end

  def display_character_info(character)
    puts "\nキャラクター名：#{character.name}"
    puts "HP：#{character.hp}"
    puts "こうげき力：#{character.attack_damage}"
    puts "こうげきタイプ：#{character.attack_type}"
    puts "プレイヤーフラグ：#{character.is_player}"
    puts "生存フラグ：#{character.is_alive}"
  end
  
  def display_status
    puts"[#{@heroes.name} HP: #{@heroes.hp} 攻撃力: #{@heroes.attack_damage}]"
    puts"[#{@monsters.name} HP: #{@monsters.hp} 攻撃力: #{@monsters.attack_damage}]"

  end

  def process_heroes_turn
    loop do
      puts"\n↓行動を選択してください"
      puts"[#{Constants::ACTTION_ATTACK}]こうげき"
      puts"[#{Constants::ACTTION_ESCAPE}]にげる"
      choice = gets.to_i

      case choice
      when Constants::ACTTION_ATTACK
        execute_attack(@heroes, @monsters)
        break
      when Constants::ACTTION_ESCAPE
        execute_escape(@heroes)
        return
      else
        puts "無効な選択肢です"
      end
    end
  end

  def process_monsters_turn
  execute_attack(@monsters,@heroes)
  end

  def execute_attack(attacker, defender)
    case attacker.attack_type
    when Constants::ATTACK_TYPE_NORMAL
      puts "#{attacker.name}のこうげき!!"
    when Constants::ATTACK_TYPE_MAGIC
      puts "#{attacker.name}の魔法こうげき!!"
    end

    damage = attacker.calculate_damage()
    defender.receive_damage(damage)

    puts "#{defender.name}に#{damage}のダメージ!!"
    puts "#{defender.name}はたおれた!" unless defender.is_alive

  end 

  def execute_escape(character)
    puts"#{character.name}は逃げ出した"
    @escape_flg = true
  end


  def start
    puts"\n◆◆◆ モンスターが現れた!! ◆◆◆"

    display_status()
    process_heroes_turn()
    if @escape_flg
      return 
    end
    process_monsters_turn()
  end




private
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
    ACTTION_ATTACK = 1
    ACTTION_ESCAPE = 2
end



game = Game.new
game.start()