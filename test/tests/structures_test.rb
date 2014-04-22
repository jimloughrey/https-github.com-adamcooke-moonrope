class StructuresTest < Test::Unit::TestCase
  
  def setup
    puts "setup"
  end
  
  def test_structures_are_defined
    assert_equal 2, $mr.structures.size
    assert_equal true, $mr.structures.all? { |s| s.is_a?(Moonrope::Structures::Structure)}
  end
  
  def test_structure_creation
    assert structure = $mr.structure(:user)
    assert_equal Moonrope::Structures::Structure, structure.class
    assert structure.basic.is_a?(Proc)
    assert structure.full.is_a?(Proc)
  end
  
  def test_structure_hash_with_basic_data
    user = User.new
    user.id = 1
    user.name = 'Adam Cooke'
    user.username = 'adam'
    user.date_of_birth = Time.new(1986, 11, 8)
    
    structure = $mr.structure(:user)
    
    hash = structure.hash(user)
    assert_equal user.id, hash[:id]
    assert_equal user.username, hash[:username]
    assert_equal false, hash.keys.include?(:name)
    
    hash = structure.hash(user, :full => true)
    assert_equal user.id, hash[:id]
    assert_equal user.username, hash[:username]
    assert_equal user.name, hash[:name]
  end
  
  def test_structure_hash_with_expansions
    user = User.new
    user.id = 1
    user.username = 'dave'
    
    animal1 = Animal.new
    animal1.id = 1
    animal1.type = 'dog'
    animal1.name = 'Fido'
    animal1.color = 'black'
    animal1.gender = 'make'
    animal1.user = user
    
    animal2 = Animal.new
    animal2.id = 2
    animal2.type = 'cat'
    animal2.name = 'Jess'
    animal2.color = 'black & white'
    animal2.gender = 'female'
    animal2.user = user
    
    user.animals << animal1
    user.animals << animal2
    
    # Test the full animal structure includes the user
    animal_structure = $mr.structure(:animal)
    hash = animal_structure.hash(animal1, :full => true)
    assert_equal animal1.name, hash[:name]
    assert_equal user.username, hash[:user][:username]
    
    # Test that a user structure with expansions includes the
    # animals which are included
    user_structure = $mr.structure(:user)
    hash = user_structure.hash(user, :expansions => true)
    assert hash[:animals].is_a?(Array), "hash[:animals] is not an array"
    assert_equal hash[:animals][0][:name], 'Fido'
    assert_equal hash[:animals][1][:name], 'Jess'
    
    # Test that when expansions was false
    hash = user_structure.hash(user, :expansions => false)
    assert_equal nil, hash[:animals], "hash[:animals] is present"
    
    # Test cases when expansions are provided as an array
    hash = user_structure.hash(user, :expansions => [:something, :else])
    assert_equal nil, hash[:animals], "hash[:animals] is present"
    hash = user_structure.hash(user, :expansions => [:animals])
    assert_equal Array, hash[:animals].class, "hash[:animals] is present"
  end
  
end