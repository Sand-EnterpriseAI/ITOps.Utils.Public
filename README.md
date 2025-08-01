# Install topgrade on a macbook

Run this command from your terminal:

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Sand-EnterpriseAI/ITOps.Utils.Public/refs/heads/main/mac/install-and-schedule-topgrade.sh)"
```

* The default script will schedule `topgrade` to run at 08h00 every Monday. Download and modify the script if you would prefer a different schedule.

* After installing you should be able to run 'topgrade' from your command line at any time to update your machine

* To verify the schedule has been set, run `bash -c "$(curl -fsSL https://raw.githubusercontent.com/Sand-EnterpriseAI/ITOps.Utils.Public/refs/heads/main/mac/check-topgrade-install.sh)"
` from your terminal

NB: It is dangerous to run scripts directly on your work machine, particularly if they use curl. Make sure they are from a trusted source.