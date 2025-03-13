
This app aims to provide easy communication across Members of the Realmen Community,
with dedicated features that are linked to the Community structure.

## Terminology
- **Member**: man that enters the Community
- **Group**: defined set of Members of the Community
- **Room**: chat room where Members can exchange messages, about a defined topic
- **Channel**: set of chat Rooms, for the same Group
- **Region**: geographical area, corresponding to an Italian region (e.g. Tuscany) 
- **Local**: referred to the same geographical area, that may coincide with a Region
- **General**: referred to the whole Community, comprising all areas and Regions

## Realmen Community structure
 
The Community is a big **General Group** of members, divided into **Local Groups** of men living in the same geographical area.

If there are a few members in a large geographical area, a single Local Group may be formed with people from nearby Regions.
If there are a lot of members in the same Region, 2 or more Local Groups may exists for the same Region. Members can be part of only one Local Group of the same Region.


## Channels and Rooms

The **General Channel** allows broad communication in the General Group.
This Channel includes:
- **General Main Room**, with all members
- **General Journal Room**, where Admins can log and summarize activities about the General Group
- **App News Room**, where new app functionalities are announced
- **Admin Room**, with All Admins (General and Local)


**Local Channels** allow communication between members of the same Local Group.
This Channels include:
- a **Local Main Room** for generic discussion and local meetings organization
- a **Local Journal Room**, where Local Admins can log and summarize activities about the Local Group

The **Dev Channel** allows communication between developers.
This Channel includes a **Dev Main Room** for generic developement discussion.

Every Channel can also have:
- **Normal Topic Rooms** to discuss about specific topics
- **Sensitive Topic Rooms** to discuss about sensitive topics

In Normal Topic Rooms, new members can read all messages, sent since room creation.
In Sensitive Topic Rooms, new members can read only messages sent after their joining to the room. In this way, older messages are hidden to new members, protecting the privacy of existing members.
Topic Room type (normal/sensitive) is assigned on room creation, and cannot be changed later.

Admins can create also **Custom rooms**, with arbitrary members.<br>
**Direct Message Rooms** allow one-to-one communication between members.


## Admin Roles

- **Admins**: they supervise the Community and manage all its Channels
- **Local Admins**: they supervise their own Local Channel
- **All Admins**: refers to Admins and Local Admins
- **Devs**: developers of the app. They have a lot of power...

At least one Admin is required, to manage Channels.
It is possible to have Local Channels without any Local Admin.


## Onboarding

**0. Sign up**<br>
Anyone can sign up specifying personal data, own living Region and **motivation**.
Once the account is created, the user is a Pending Member.

**1. Pending Member**<br>
He has a **locked account**, with no access to Channels or Rooms.
Admins can review and approve his request to enter the Community, so he becomes a New Member.

**2. New Member**<br>
He has access to the **General Channel** (General Room, Journal Room and Normal Topic Rooms), and Direct Message Rooms.
He can view General Sensitive Topic Rooms, and request to enter them.
He can view the list of Local Channels, and **request to enter** in one of them.
The request is shown in the Local Main Room, so that all members of the Local Channel can see it. 
The Local Admin can approve the request, so that the member becomes a Visitor Member.

**3. Visitor Member**<br>
He is not officially part of the Local Group, in fact he has **partial access to Local Channel**, since he cannot read Local Journal Room and Sensitive Topic Rooms).
After some observation time, the Local Admin can propose the offical entrance of the Visitor Member into the Local Group, sending a request to all Channel Members, that can vote to make him become an Approved Member, only if all Members approve.
Otherwise, the Local Admin can remove the Visitor Member from the Local Channel.

**4. Approved Member**
He is officially part of the Local Group, in fact he has **complete access to Local Channel**, since he can read messages Local Journal Room, read and write in Sensitive Topic Rooms, and approve new members.
For Local Channels without Local Admins (e.g. newly created Channels) Approved Members can request to become Local Admin, accepted only if all the other Members vote to accept.

**5. Local Admin**
He **manages the Local Channel**, writing updates in the Local Journal Room, and creates or deletes Local Topic Rooms.
He cannot directly remove Approved Members from the Channel, but he can **propose to remove one**, sending a request to all the other Members, that can vote.
He can give up its Local Admin role, or extend it to another Approved Member.

**6. Dev**
Developers have access to the Dev Channel (Dev Main Room and Normal Topic Rooms).
They have access to app code and database, so they have a lot of power, but they should use it only for development purposes.
They have the role to add new admins and devs if needed, acting on database.

**7. Admin**
Admins can view, read and write (?) in all Rooms of all Channels, including Sensitive Topic Rooms (?).
They can create and delete Local Channels, change Local Admins, remove members from Local Channels without members approval.


## Permissions

Available room permissions:
- **View**: view room name, description, and members
- **Read**: read only room messages, only after room joining date
- **Read All**: read all messages, from room creation
- **Write**: write new messages to the room
- **Manage**: change room name and details, pin messages

Every user can edit or delete only own messages.
Permissions depend on user role, and channel membership.

### General Channel

- **General Main Room**: everyone can View, Read All, Write. Admins can Manage. Admins can delete messages by others.
- **General Journal Room**: everyone can View, Read All, not Write. Admins can Write and Manage.
- **General Normal Topic Room**: everyone can View, Read All, Write. Admins can Manage.
- **General Sensitive Topic Room**: everyone can View, only room members can Read (not All!) and Write. Admins can Manage.


### Local Channels

- **Local Main Room**: channel members can View, Read All, Write. Local Admins can Manage. Unlike General Channel, Local Admins cannot delete messages by others.
- **Local Journal Room**: channel approved members can View, Read All, not Write. Local Admins can Write and Manage.
- **Local Normal Topic Room**: channel members can View, Read All, Write. Admins can Manage.
- **Local Sensitive Topic Room**: channel approved members can View, can Read (not All!) and Write. Admins can Manage.

Non-members of the Local Channel can view only members and their roles, not View rooms.

### Other rooms
- **Dev Channel**: same permissions as a Local Channel, except for membership, controlled directly by Admins.
- **Custom Rooms**: only room members can View, Read All and Write. Admins can Manage, and add/remove members.
