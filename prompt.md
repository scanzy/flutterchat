This file serves as basis for AI prompts...


# Prompt usage

To craft effective prompts, use the CIDI framework (C: context, I: instructions, D: details, I: input)

-- START OF PROMPT --

You are an AI writing fully working code for a cross-platform chat app.

## Presentation

Use these libraries:

- Back end: pocketbase
- Front end: Flutter


## Code style

Insert one blank line to separate code blocks.
Insert 2 blank lines between functions and classes.

Comment every code block and provide a short description of every class.

# Auth page

Two modes are possibile: login and register, starting from login.

Login:

- email field
- password field
- login button
- link "New here? Create an account"

Register:

- nickname field
- email field
- password field
- password confirm
- register button
- link "Already have an account? Login"

Extra (for both modes):

- go directly to chat page) if credentials are stored
- show app title "App" on top
- use centered layout
- add basic validation functionality to avoid blank fields, invalid emails, duplicate usernames, weak passwords, unmatching passwords


# Chat page

## Title bar

- back button (acts as logout)
- chat title "Branco", that opens chat details page on tap
- search button, that shows searchbar, up/down result navigation buttons, result counter, close search X icon

## Messages area

- sticky banner with pinned message preview (go to message on tap)
- list of messages, contained in balloons:
  - messages by me: right
  - messages by others: left
- N unread messages title
- sticky day

Every message has:

- username (bold), with random color
- admin tag (if admin)
- message text, making urls clickable, and formatting them with underscore and different colors
- status text "Sending..." or "Sent at `<hour>`"
- reactions cards, with icon and count
- circle with uppercase initial of the username, and same color of the username

Action buttons (visible on hover, or long tap on mobile):

- copy to clipboard
- react to message (emoji icon), showing emoji selection popup
- edit message (only messages by me), copying message on text field
- delete message (only messages by me), showing a confirm
- pin message (only for admin)

Extra:

- autoscroll on new messages, with animation
- disable autoscroll if reading old messages

## New message text field

- send message button
- attach file or image button, showing selection popups

Extra:

- send message on enter press
- on desktop: use ctrl+enter or shift+enter to create multiple line messages
- when editing a message: display pencil icon and original message (go to message on tap)
- when replying to message: display reply icon and message we are replying to (go to message on tap)


# Chat details page

## Topbar

- back button
- Title "Chat details"

## Chat info

- Centered big round photo of the chat, that goes fullscreen on tap
- Edit button next to the photo
- Field to edit chat name

## Members info

- Text "N members"
- add member button
- list of members, with "admin" tag near admins


-- END OF PROMPT --
