#file: spec/integration/app_spec.rb

require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_artists_table
  seed_sql = File.read('data/data_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_db_test' })
  connection.exec(seed_sql)
end

describe Application do

  include Rack::Test::Methods

  let(:app) { Application.new }

  before(:each) do 
    reset_artists_table
  end

     context 'GET /albums/new' do 
       it 'should return the html form to create a new task' do 
          response = get('albums/new')

          expect(response.status).to eq(200)
          expect(response.body).to include('<h1>Add a new album</h1>')
          expect(response.body).to include('form action="/albums" method="POST">')
        end
      end

      context 'GET /artists/new' do 
        it 'should return a form to create a new artist' do
          response = get('artists/new')

          expect(response.status).to eq(200)
          expect(response.body).to include('<h1>Add a new artist</h1>')
          expect(response.body).to include('form action="/artists" method="POST">')
        end
      end

      context "POST /artists" do
        it 'returns a success page' do

          response = post(
            '/artists',
            name: 'Test',
            genre: 'Pop',
          )
          expect(response.status).to eq(200)
          expect(response.body).to include('<h1>You saved artist: Test</h1>')
        end
      end

      context "POST /albums" do
        it 'returns a success page' do
  
          response = post(
            '/albums',
            title: 'Test',
            release_year: '1990',
            artist_id: '1'
          )
          expect(response.status).to eq(200)
          expect(response.body).to include('<h1>You saved album: Test</h1>')
        end
      end

    context 'GET /albums' do 
    it "return a list of albums" do
    response = get('/albums')

    expect(response.status).to eq(200)
    expect(response.body).to include('<a href="/albums/1">Doolittle</a><br />')
    expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a><br />')
    expect(response.body).to include('<a href="/albums/3">Waterloo</a><br />')
  end
end
    context 'GET /artists' do 
      it " return all artists" do 
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a><br />')
      expect(response.body).to include('<a href="/artists/2">ABBA</a><br />')
      expect(response.body).to include('<a href="/artists/3">Taylor Swift</a><br />')
      expect(response.body).to include('<a href="/artists/4">Nina Simone</a><br />')
      end
    end

    context 'GET /albums/:id' do
      it 'returns the HTML content for single album 2' do 
        response = get('/albums/2')

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Surfer Rosa</h1>')
        expect(response.body).to include('Release year: 1988')
        expect(response.body).to include('Artist: Pixies')
      end
    end
  
    context 'GET /artists/:id' do
     it 'returns the content for a single artists' do 
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
     end
    end
  end