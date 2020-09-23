# skopos-plugin-swarm-exec

[![Join the chat at https://gitter.im/datagridsys/skopos](https://badges.gitter.im/datagridsys/skopos.svg)](https://gitter.im/datagridsys/skopos?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A tool for executing commands in service containers deployed on Docker swarm - equivalent to:

`docker service exec <task_id> <command> <args>`

## Background

Docker Swarm does not yet provide a way to execute commands inside a service
task from the manager node (CLI or API). This project provides an easy-to-use
mechanism for doing just that: executing a command in the container of a service task.

Think of it as a `docker service exec` that applies to a specific task of a service.

The need for this project is expected to go away when the
[Support for executing into a task #1895](https://github.com/docker/swarmkit/issues/1895)
issue is resolved in the Docker swarm project and the same capability becomes available
directly in the Docker swarm API and command-line client. 

The exec capability, together with `docker service logs` (already included in Docker 17.05.0-ce as non-experimental), a `docker service signal`, as well as pause/resume, will provide closure of the container operation functions between plain Docker containers and services that run containers on a swarm cluster.

## Standalone Use

On the swarm manager node, run the following command:

```
docker run -v /var/run/docker.sock:/var/run/docker.sock
    sjurkuhn/docker-swarm-exec \
    task-exec <taskID> <command> [<arguments>...]
```

where:

* `<taskID>` is the task ID of the task in which you want to execute a command (see task IDs with `docker service ps <service_name>`)
* `<command>` command to execute (e.g. `curl`)
* `<arguments>...` zero or more arguments to pass to the command (e.g., `http://example.com/file`)

>Note: it is possible to use the `swarm-exec` script directly, if python3 and
the docker Python SDK are installed. The container packaging is easier to use in most cases.

## How It Works (Internals)

Starting from a task ID and a command to execute, here are the steps that are taken:

1. Obtain the node ID on which the target task is running, as well as the container ID
of the task on that node
1. Create a temporary service, using the same container image, and a scheduling constraint
that places the task of the temporary service on the same node where the target task is
1. Execute the equivalent of a `docker exec` command using the node-local Docker engine API
1. Upon completion of the command, terminate the temporary service, propagating the exit code of the executed command
1. Upon termination of the temporary service, extract the exit code and return it

## License

This is an open source project. See the [LICENSE](LICENSE) file.

## Contributing

If you want to propose an improvement, issues and pull requests are always welcome!
