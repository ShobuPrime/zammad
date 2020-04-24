# zammad
Zammad docker container with managed data volume, based on https://hub.docker.com/r/zammad/zammad/.

**Zammad** is a web based open source helpdesk/ticket system with many features to manage customer communication via several channels like telephone, facebook, twitter, chat and e-mails. It is distributed under the GNU AFFERO General Public License (AGPL). Do you receive many e-mails and want to answer them with a team of agents? You're going to love Zammad!

Run command:
```bash
docker container run -id --name zammad -p 80:80 shobuprime/zammad:latest
```
* For managed data bind-mount folder add ```-v /zammad:/shared/zammad_data```.
* For backups add ```-v /zammad_backup:/shared/zammad_backup``` and read [this](https://docs.zammad.org/en/latest/appendix/backup-and-restore.html).