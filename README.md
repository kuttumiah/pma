## About

Simple shell script that automatically installs the latest version of phpMyAdmin
on a Laravel Homestead box.

## Usage

1. SSH into your Homestead box `homestead ssh` or `vagrant ssh`

2. `cd` to your code/projects directory (by default `~/Code`)

3. `$ curl -sS https://raw.githubusercontent.com/kuttumiah/pma/master/pma.sh | sh`

4. Open the `/etc/hosts` (Mac/Linux) or `C:\Windows\System32\drivers\etc\hosts` (on Windows) file on your main machine and add `127.0.0.1  phpmyadmin.test`

5. Go to [http://phpmyadmin.test](http://phpmyadmin.test). Default credentials are username `homestead` and password `secret`

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
