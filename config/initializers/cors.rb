# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:8000'  # Substitua pela URL do seu frontend se necessário, ou use '*' para permitir qualquer origem
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        expose: ['Authorization'],
        max_age: 600
    end
  end
  