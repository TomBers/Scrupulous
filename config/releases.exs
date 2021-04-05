import Config

db_url = System.get_env("DATABASE_URL")

config :scrupulous, ScrupulousWeb.Endpoint,
       secret_key_base: "LkrIIPvPC9XgMqkhgH1RsOn+CyJ+Th/dVRKSxxjE86A+oeEPIal9Gr4DXOffUKjR"

# Configure your database
config :scrupulous, Scrupulous.Repo,
       ssl: true,
       url: db_url,
       pool_size: 15

#       DB has gone down