require 'sinatra'
require 'csv'

get '/' do
  erb :index
end

post '/raffle_results' do
  file = params[:file][:tempfile]
  @list = weight_the_raffle(file)
  choose_the_winners(@list)
  erb :raffle_results
end

private

def weight_the_raffle(file)
  list_of_names = []
  @ticket_list = []
  csv_text = File.read(file)
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    values = row.to_s.split(',')
    @ticket_list << "#{values[1]}- #{values[0]} tickets"
    number_of = values[0].to_i
    number_of.times do |x|
      list_of_names.push(values[1])
    end
  end
  list_of_names
end

def choose_the_winners(list)
  @winners = []
  until @winners.count == 3 do
    possible_winner = list.sample
    if @winners.empty?
      @winners << possible_winner
    elsif @winners.include?(possible_winner)
      next
    else
      @winners << possible_winner
    end
  end
end


