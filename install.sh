# install Citus from source
sudo apt update -y
sudo apt install git -y
sudo apt install build-essential -y
sudo apt install liblz4-dev -y
sudo apt install libzstd-dev -y
sudo apt install clang-11 -y
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

# restart postgresql.service
sudo systemctl restart postgresql.service
CREATE EXTENSION citus;

# test to see if Citus is working
sudo -u postgres psql postgres -c "select citus_version();"
