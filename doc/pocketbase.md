## Pocketbase collections

Two pocketbase collections are needed:
- users
- messages


### users

It contains auth infos for users, it is compiled at registration and can be edited from the profile page.


| Field            | Type     |
|------------------|----------|
| id               | string   |
| password         | password |
| tokenKey         | string   |
| email            | email    |
| emailVisibility  | bool     |
| verified         | bool     |
| name             | string   |
| avatar           | image    |
| username         | string   |
| admin            | bool     |
| created          | date     |
| updated          | date     |


### messages

At the moment only one room is present

| Field            | Type     |
|------------------|----------|
| id               | string   |
| message          | string   |
| user             | relation to users |
| replyTo          | relation to messages |
| reaction         | json     |
| pinned           | bool     |
| created          | date     |
| updated          | date     |
