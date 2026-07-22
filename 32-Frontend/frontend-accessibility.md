# Frontend Accessibility

This document covers web accessibility standards, techniques, and best practices.

## What is Web Accessibility?

Web accessibility means that websites, tools, and technologies are designed and developed so that people with disabilities can use them. More specifically, people can perceive, understand, navigate, and interact with the Web.

## WCAG Guidelines

The Web Content Accessibility Guidelines (WCAG) define how to make web content more accessible.

### Four Principles (POUR)
1. **Perceivable**: Information must be presentable to users in ways they can perceive
2. **Operable**: Interface components must be operable by all users
3. **Understandable**: Information and UI operation must be understandable
4. **Robust**: Content must be robust enough to be interpreted by assistive technologies

### Conformance Levels
- **Level A**: Minimum level of accessibility
- **Level AA**: Addresses the most common barriers
- **Level AAA**: Highest level of accessibility

## Semantic HTML

### Use Proper Elements
```html
<!-- Bad -->
<div class="button">Click me</div>
<div class="heading">Title</div>

<!-- Good -->
<button>Click me</button>
<h1>Title</h1>
```

### Landmark Roles
```html
<header>Site header</header>
<nav>Navigation</nav>
<main>Main content</main>
<aside>Sidebar</aside>
<footer>Site footer</footer>
```

### Headings Structure
```html
<h1>Main Page Title</h1>
<h2>Section Title</h2>
<h3>Subsection Title</h3>
```

## ARIA Attributes

### ARIA Roles
```html
<div role="alert">Error message</div>
<div role="tab">Tab label</div>
<div role="tabpanel">Tab content</div>
```

### ARIA States
```html
<button aria-pressed="false">Toggle</button>
<input aria-invalid="true" aria-describedby="error">
<div aria-hidden="true">Decorative content</div>
```

### ARIA Labels
```html
<input aria-label="Search">
<button aria-labelledby="label-text">Click me</button>
<nav aria-label="Main navigation">...</nav>
```

## Keyboard Navigation

### Focus Management
```css
/* Visible focus indicators */
:focus {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
}

/* Remove default outline only when replacing */
:focus:not(:focus-visible) {
  outline: none;
}

:focus-visible {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
}
```

### Skip Links
```html
<a href="#main-content" class="skip-link">Skip to main content</a>

<style>
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #005fcc;
  color: white;
  padding: 8px;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
</style>
```

### Keyboard Shortcuts
```javascript
document.addEventListener('keydown', (e) => {
  // Escape key closes modals
  if (e.key === 'Escape') {
    closeModal();
  }
  
  // Tab key manages focus
  if (e.key === 'Tab') {
    handleTabNavigation(e);
  }
});
```

## Color and Contrast

### Contrast Ratios
- **Normal text**: Minimum 4.5:1 contrast ratio
- **Large text**: Minimum 3:1 contrast ratio
- **UI components**: Minimum 3:1 contrast ratio

### Color Independence
- Don't use color alone to convey information
- Use icons, patterns, or text in addition to color
- Provide sufficient contrast between colors

### Testing Tools
```css
/* Check contrast with browser dev tools */
/* Use WebAIM Contrast Checker */
/* Use axe DevTools extension */
```

## Forms and Inputs

### Label Association
```html
<!-- Explicit labeling -->
<label for="email">Email:</label>
<input type="email" id="email" name="email">

<!-- Implicit labeling -->
<label>
  Email:
  <input type="email" name="email">
</label>
```

### Error Handling
```html
<input 
  aria-invalid="true" 
  aria-describedby="email-error"
  type="email" 
  id="email"
>
<span id="email-error" role="alert">
  Please enter a valid email address
</span>
```

### Required Fields
```html
<label for="name">
  Name <span aria-hidden="true">*</span>
  <span class="sr-only">(required)</span>
</label>
<input type="text" id="name" required aria-required="true">
```

## Images and Media

### Alternative Text
```html
<!-- Informative image -->
<img src="chart.png" alt="Sales increased 25% from Q1 to Q2 2024">

<!-- Decorative image -->
<img src="divider.png" alt="" role="presentation">

<!-- Complex image -->
<figure>
  <img src="complex-chart.png" alt="Revenue breakdown by region" aria-describedby="desc">
  <figcaption id="desc">Detailed description of the chart...</figcaption>
</figure>
```

### Video Accessibility
```html
<video controls>
  <source src="video.mp4" type="video/mp4">
  <track kind="captions" src="captions.vtt" srclang="en" label="English">
  <track kind="descriptions" src="descriptions.vtt" srclang="en" label="English">
</video>
```

## Dynamic Content

### Live Regions
```html
<!-- Polite announcements -->
<div aria-live="polite" aria-atomic="true">
  Status: Loading...
</div>

<!-- Assertive announcements -->
<div aria-live="assertive" role="alert">
  Error: Form submission failed
</div>
```

### Loading States
```html
<div aria-busy="true" aria-live="polite">
  <span class="spinner" aria-hidden="true"></span>
  Loading data...
</div>
```

## Testing Accessibility

### Automated Tools
- **axe DevTools**: Browser extension for testing
- **Lighthouse**: Built into Chrome DevTools
- **WAVE**: Web accessibility evaluation tool
- **pa11y**: Command line tool for accessibility testing

### Manual Testing
1. **Keyboard Navigation**: Tab through entire page
2. **Screen Reader**: Test with NVDA, VoiceOver, or JAWS
3. **Zoom**: Test at 200% zoom level
4. **Color Contrast**: Check with contrast analyzer

### Testing Checklist
- [ ] All images have appropriate alt text
- [ ] Form inputs have associated labels
- [ ] Color contrast meets WCAG standards
- [ ] Keyboard navigation works throughout
- [ ] Screen reader can navigate the page
- [ ] Focus indicators are visible
- [ ] Error messages are accessible
- [ ] Dynamic content is announced

## Common Accessibility Issues

### Missing Alt Text
- Add descriptive alt text to informative images
- Use empty alt="" for decorative images
- Don't start alt text with "Image of..."

### Poor Color Contrast
- Use tools to check contrast ratios
- Don't rely on color alone for meaning
- Provide sufficient contrast for text and backgrounds

### Keyboard Traps
- Ensure all interactive elements are keyboard accessible
- Test tab order through entire page
- Provide skip links for navigation

### Missing Form Labels
- Associate labels with inputs
- Use aria-label when visual labels aren't possible
- Provide clear error messages

## Resources

- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM](https://webaim.org/)
- [A11y Project](https://www.a11yproject.com/)
- [axe Documentation](https://www.deque.com/axe/)

## See Also

- [[frontend-guide]]
- [[frontend-performance]]
- [[frontend-frameworks]]
- [[frontend-interview-questions]]
