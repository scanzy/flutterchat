## Pocketbase collections

The pocketbase server has these collections:
- `users`: auth info and personal data of users
- `messages`: messages sent in the chat
- `reactions`: reactions to messages
- `rooms`: name, type and other data of rooms
- `roomsMembers`: members of rooms, with joining date
- `regions`: italy regions for channels
- `channels`: name, region and other data of channels
- `channelsMembers`: members of channels, with status

Note: datetime fields are in UTC timezone, so they need to be converted to local time when displaying them.


### `users`

It contains auth infos for users, it is compiled at registration and can be edited from the profile page.


| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `password`         | password |
| `tokenKey`         | string   |
| `email`            | email    |
| `emailVisibility`  | bool     |
| `verified`         | bool     |
| `name`             | string   |
| `avatar`           | image    |
| `username`         | string   |
| `admin`            | bool     |
| `created`          | datetime |
| `updated`          | datetime |

**API rules**
No rules configured!


### `messages`

At the moment only one room is present

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `message`          | string   |
| `user`             | relation to users |
| `replyTo`          | relation to messages |
| `reaction`         | json     |
| `pinned`           | bool     |
| `created`          | datetime |
| `updated`          | datetime |
| `contentEditedAt`  | datetime |

Note: `contentEditedAt` is null by default, but it is set to the current datetime every time the message is updated. The `updated` field cannot be used for this, since it is updated automatically by pocketbase for any update to the message record, e.g. when the message is pinned/unpinned.

**API rules**
- list: @request.auth.id != ""
- view: @request.auth.id != ""
- create: @request.auth.id != "" && @request.auth.id = user
- update: @request.auth.admin = true || @request.auth.id = user
- delete: @request.auth.admin = true || @request.auth.id = user
