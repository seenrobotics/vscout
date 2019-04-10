import sys

import click


@click.group(short_help='Graph team statistics')
@click.argument('stat')
def graph(stat):
    click.echo(stat)


@graph.command()
def ls():
    pass


@graph.command()
def save():
    pass
