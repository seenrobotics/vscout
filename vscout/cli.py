import sys

import click

from misc import commands as misc
from graph import commands as graph
from server import commands as server


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
entry_point.add_command(server.server)

if __name__ == "__main__":
    main()
