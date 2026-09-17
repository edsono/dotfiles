---
name: ux-guidelines
description: General UX and form design guidelines. Use when designing UI flows, forms, tables, and messaging.
---

# General UX Guidelines

## Responsive Design
- Design mobile-first; scale up for larger screens.
- Avoid control overload on small screens; stack or collapse as needed.

## Tables and Actions
- Prefer clear primary actions; keep secondary actions visually lighter.
- Use icon+text on larger screens and icon-only on small screens.
- Keep action placement consistent across screens.
- Em DataTables com datas exibidas como `dd/mm/aaaa`, manter a exibição para o usuário e definir `data-order` em ISO (`aaaa-mm-dd`) para ordenação correta.

## Empty and Error States
- Show empty-state messaging when no records exist.
- Place error messages prominently before the main content.

## Forms
- Keep labels clear and visible; do not rely on placeholders as labels.
- Use placeholders only for examples or expected formats.
- Group related fields and keep a logical order.
- Keep destructive actions clearly separated and confirmed.

## Validation and Feedback
- Provide specific, actionable error messages in the user’s language.
- Show success feedback after actions complete.
- Prevent double-submits and show a loading state during processing.

## Accessibility
- Preserve natural tab order (DOM order == visual order).
- Avoid positive tabindex overrides.
- Ensure all fields are keyboard-accessible.

## Autocomplete
- Disable autocomplete only for sensitive or temporary fields.
- Prefer semantic autocomplete values for common inputs (name, email, phone, address).
