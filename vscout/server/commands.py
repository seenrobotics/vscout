import os

import click


@click.group(help='Wrapper around Docker for starting the database server')
def server():
    pass


@server.command(help="Create a PostgreSQL server to store information on the database")
@click.option('--name', default='docker-pg', help="Default: 'docker-pg' \nThe name of the created server")
@click.option('--port', default='5432:5432', help="Default: '5432:5432' \nThe port the database server will listen on.")
def start(name, port):
    os.system("docker run --rm --name=%s -e POSTGRES_PASSWORD=docker -d -p %s -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres" %
              (name, port))


@server.command(help='List information about the running servers, sorted alphabetically')
def ls():
    os.system("docker ps -a")


@server.command(help='Display information about the server')
@click.argument('container_name')
def info(container_name):
    os.system('docker stats %s' % (container_name))
    pass


@server.command(help="Rename a server's name")
@click.argument('container_name')
@click.argument('modified_container_name')
def rename(container_name, modified_container_name):
    click.echo('Name: %s\nModified Name: %s') % (
        container_name, modified_container_name)


@server.command(help="Stop a currently running database server")
@click.argument('container_name')
def stop(container_name='pg-docker'):
    os.system("docker stop %s" % (container_name))


@server.command('password', help="Change server's password")
@click.argument('container_name')
def change_password(container_name):
    pass
