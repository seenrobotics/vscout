import click
import sys

from misc import commands as misc
from graph import commands as graph


def main():
    try:
        ctx_obj = dict()
        entry_point.main(prog_name='vscout', obj=ctx_obj)
    except KeyboardInterrupt:
        click.echo('Aborted!')


@click.group()
@click.version_option(version="0.0.1")
def entry_point():
    pass


entry_point.add_command(graph.graph)

if __name__ == "__main__":
    main()
