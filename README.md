# Install topgrade on a macbook
bash -c "$(curl -fsSL https://yourcompany.internal/scripts/setup-topgrade-launchagent.sh)"

The default script will schedule `topgrade` to run at 08h00 every Monday. Download and modify the script if you would prefer a different schedule.


NB: It is dangerous to run scripts directly on your work machine, particularly if they use curl. Make sure they are from a trusted source.