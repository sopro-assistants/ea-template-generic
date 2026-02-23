---
type: todos
---

# Tasks

> [!info]- Format Reference
> See [[task-format]] for full format, fields, and query examples.
>
> **Quick format:** `- [ ] Task | [[Project]] | from [[Person]] | @Assignee | 📅 YYYY-MM-DD`
>
> **Assignee:** `@Claude` to delegate, omit for yourself (default)

---

## Overdue

```tasks
not done
due before today
path includes todos
```

---

## Due Today

```tasks
not done
due on today
path includes todos
```

---

## High Priority

<!-- Add urgent/important tasks here -->

---

## This Week

```tasks
not done
due after today
due before next week
path includes todos
```

---

## Upcoming

```tasks
not done
due after next week
path includes todos
```

---

## No Date

```tasks
not done
no due date
path includes todos
not done
```

---

## Recurring

```tasks
not done
is recurring
path includes todos
```

---

## Waiting On

*Tasks delegated to others - check back on these*

| Task | Delegated To | Date | Check Back |
|------|--------------|------|------------|
| | | | |

---

## Assigned to Claude

```tasks
not done
description includes @Claude
path includes todos
```

*Add tasks with `@Claude` to assign to Claude, or tell Claude directly.*

---

## Claude Completed (This Week)

```tasks
done
description includes @Claude
path includes todos
done after 7 days ago
sort by done reverse
```

---

## Completed (This Week)

```tasks
done
path includes todos
done after 7 days ago
description does not include @Claude
sort by done reverse
```

---

## Archive

<!-- Completed items below - displayed via live queries above -->
