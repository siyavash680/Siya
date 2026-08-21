# To-Do List Application

A modern, responsive to-do list application with local storage functionality. Built with vanilla HTML, CSS, and JavaScript.

## Features

✅ **Add Tasks** - Easily add new tasks with a clean input interface

✅ **Mark Complete** - Check off completed tasks with visual feedback

✅ **Delete Tasks** - Remove individual tasks when no longer needed

✅ **Filter Tasks** - View all tasks, only active, or only completed tasks

✅ **Local Storage** - All tasks are automatically saved to your browser's local storage

✅ **Statistics** - Track total and completed tasks at a glance

✅ **Responsive Design** - Works perfectly on desktop, tablet, and mobile devices

✅ **Beautiful UI** - Modern gradient design with smooth animations

## Files

- `index.html` - HTML structure and markup
- `style.css` - Styling and responsive design
- `script.js` - JavaScript logic and local storage management
- `README.md` - Project documentation

## How to Use

1. **Open the Application**
   - Open `index.html` in your web browser

2. **Add a Task**
   - Type your task in the input field
   - Click the "Add" button or press Enter

3. **Manage Tasks**
   - Check the checkbox to mark a task as complete
   - Click "Delete" to remove a task

4. **Filter Tasks**
   - Click "All" to see all tasks
   - Click "Active" to see only incomplete tasks
   - Click "Completed" to see only completed tasks

5. **Clear Completed**
   - Click "Clear Completed" to remove all completed tasks at once

## Technical Details

### Local Storage
The application uses the browser's `localStorage` API to persist data:
- Tasks are automatically saved whenever you add, complete, or delete a task
- When you reload the page, all your tasks are restored
- Data is stored with the key `todoList`

### Data Structure
Each task is stored as an object:
```javascript
{
    id: timestamp,
    text: "Task description",
    completed: false,
    createdAt: "date string"
}
```

## Browser Compatibility

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Any browser with ES6 and localStorage support

## Keyboard Shortcuts

- **Enter** - Add a new task (while typing in the input field)

## Customization

You can customize the app by modifying:

- **Colors** - Edit the gradient colors in `style.css`
- **Font** - Change the font-family in the `body` selector
- **Storage Key** - Modify `STORAGE_KEY` in `script.js` to use a different storage identifier
- **UI Text** - Update the placeholder text and button labels in `index.html`

## Future Enhancements

- Add due dates and reminders
- Implement task categories/tags
- Add priority levels
- Export/import tasks
- Dark mode toggle
- Task editing functionality
- Drag and drop reordering

## License

Open source - Feel free to use and modify!
