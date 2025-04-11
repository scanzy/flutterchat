## Pocketbase collections

The pocketbase server has these collections:
- `users`: auth info and personal data of users
- `regions`: italy regions for channels
- `channels`: name, region and other data of channels
- `channelsMembers`: members of channels, with status
- `rooms`: name, type and other data of rooms
- `roomsMembers`: members of rooms, with joining date
- `messages`: messages sent in the chat
- `reactions`: reactions to messages

Note: datetime fields are in UTC timezone, so they need to be converted to local time when displaying them.


### `users`

This collection contains auth info for users, it is compiled at registration and can be edited from the profile page.

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `password`         | password |
| `tokenKey`         | string   |
| `email`            | email    |
| `emailVisibility`  | bool     |
| `verified`         | bool     |
| `data` (TODO)      | json     |
| `avatar`           | file     |
| `username`         | string   |
| `admin`            | bool     |
| `created`          | datetime |
| `updated`          | datetime |

**API rules**
- TODO: allow create anyone
- TODO: allow edit only own profile, except verified and admin fields
- TODO: allow delete only own profile, or by admins


### `regions` (TODO)

This collection contains the italian regions, used to group channels.

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `name`             | string   |
| `data`             | json     |

**API rules**:
- TODO: allow only read access to regions


### `channels` (TODO)

This collection contains the channels, which are used to group users and rooms.

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `name`             | string   |
| `region`           | multiple relation to regions |
| `data`             | json     |
| `created`          | datetime |
| `createdBy`        | single relation to users |

**API rules**:
- TODO: allow edit only for admins and local admins
- TODO: allow create and delete only for admins


### `channelsMembers` (TODO)

This collection contains the members of the channels.

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `user`             | single relation to users |
| `channel`          | single relation to channels |
| `admin`            | bool     |
| `proposedAt`       | datetime |
| `joinedAt`         | datetime |
| `approvedAt`       | datetime |
| `removedAt`        | datetime |
| `admittedBy`       | single relation to users   |
| `approvedBy`       | multiple relation to users |
| `removedBy`        | multiple relation to users |

**API rules**
- TODO: allow create/edit only for admins and local admins
- TODO: allow delete only for admins


### `rooms` (TODO)

This collection contains the rooms, which are used to group messages and users.

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `name`             | string   |
| `type`             | select   |
| `image`            | file     |
| `data`             | json     |
| `channel`          | single relation to channels |
| `created`          | datetime |
| `createdBy`        | single relation to users |

Available values for type:
- `generic`: main room of channel, only one per channel
- `journal`: only admin can write
- `topic`: secondary room of the channel
- `private`: no access to old messages for new users
- `custom`: room without channel

**API rules**
- TODO: access rooms based on membership
- TODO: edit/delete rooms only for admins


### `roomsMembers` (TODO)

This collection contains the members of the rooms.

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `user`             | single relation to users |
| `room`             | single relation to rooms |
| `admin`            | bool     |
| `addedAt`          | datetime |
| `removedAt`        | datetime |
| `addedBy`          | single relation to users |
| `removedBy`        | single relation to users |

**API rules**:
- TODO: allow create/edit/delete only for room admins


### `messages`

This collection contains the messages sent in the chat, which can be text, images or files.

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `message`          | string   |
| `media`            | file     |
| `room`             | single relation to rooms |
| `user`             | single relation to users |
| `replyTo`          | single relation to messages |
| `reactions`        | multiple relation to reactions |
| `pinned`           | bool     |
| `pinnedBy` (TODO)  | single relation to messages |
| `pinnedAt` (TODO)  | datetime |
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

TODO: access messages based on room membership and type!


### `reactions` (TODO)

| Field              | Type     |
|--------------------|----------|
| `id`               | string   |
| `message`          | single relation to messages |
| `user`             | single relation to users |
| `emoji`            | string   |
| `created`          | datetime |

**API rules**
- TODO: view reactions based on room membership
- TODO: edit/delete only own reactions

