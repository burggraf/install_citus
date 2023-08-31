# dependencies
sudo apt update -y
sudo apt install git -y
sudo apt install build-essential -y
sudo apt install liblz4-dev -y
sudo apt install libzstd-dev -y
sudo apt install clang-11 -y
sudo apt install libcurl4-openssl-dev -y
sudo apt-get install libkrb5-dev -y
sudo apt install libicu-dev -y

# install postgresql-server-dev
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-server-dev-15 -y

# install citus
git clone https://github.com/citusdata/citus.git
cd citus
./configure
make
sudo make install

# install pg_conftool
sudo apt install postgresql-common -y

# add citus to the BEGINNING of shared_preload_libraries
sudo sed -i "s/shared_preload_libraries = 'pg_stat_statements/shared_preload_libraries = 'citus, pg_stat_statements/" /etc/postgresql/postgresql.conf
# sudo pg_conftool 14 main set shared_preload_libraries citus

# restart postgresql
sudo systemctl restart postgresql

# turn on Citus extension, check version to make sure it's working
sudo apt install postgresql-client -y
psql -U supabase_admin -h localhost -d postgres -c "CREATE EXTENSION citus;select citus_version();"
