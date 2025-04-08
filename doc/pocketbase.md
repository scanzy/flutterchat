## Pocketbase collections

Two pocketbase collections are needed:
- `users`
- `messages`

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

Note 2: `contentEditedAt` is null by default, but it is set to the current datetime every time the message is updated. The `updated` field cannot be used for this, since it is updated automatically by pocketbase for any update to the message record, e.g. when the message is pinned/unpinned.
