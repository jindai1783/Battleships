require './lib/ship_section'
require './lib/coordinate_methods'

class Ship
  attr_reader :ship_body

  def initialize(build_options = {})
    @build_type =    build_options[:type] || ShipSection
    build_ship_using build_options
  end

  def measure_length
    @ship_body.count
  end

  def damage_report
    @ship_body.select {|section| section.hit? }.count
  end

  def sunk?
    damage_report == measure_length
  end

  # private

  def build_ship_using build_options
    build_plan =         make_build_plan_from build_options
    build_sections_using build_plan
  end

  def make_build_plan_from build_options
    build_plan = [build_options[:head]]
    until build_plan.last == build_options[:tail]
      build_plan << next_section_location([build_plan.last,build_options[:tail]])
    end
    build_plan
  end

  def build_sections_using build_plan
    @ship_body = build_plan.map {|coordinate| ShipSection.new(coordinate)}
  end
  
  def next_section_location(coordinates) 
  # takes an array of two arrays [[x,y],[x,y]]:
  # first array contains coordinates of the ship section that was built last.
  # second array contains coordinates of tail section
  # returns [x,y] with either x or y increased/decreased in the direction of tail (no diagonals allowed).


    current_x = coordinates[0][1]
    current_y = coordinates[0][0]
    tail_x    = coordinates[1][1]
    tail_y    = coordinates[1][0]

    x_difference = tail_x - current_x
    y_difference = tail_y - current_y

    if (x_difference.abs <=> y_difference.abs) == 1
      axis_to_change = :x
    else
      axis_to_change = :y
    end

    if axis_to_change == :x
      if x_difference > 0
        new_x = current_x + 1
      else
        new_x = current_x - 1
      end
      new_y = current_y
    elsif axis_to_change == :y
      if y_difference > 0
        new_y = current_y + 1
      else
        new_y = current_y - 1
      end
      new_x = current_x
    end

    [new_y,new_x]
  end
end