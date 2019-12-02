# NibJect

---

## Requirements

### Read Nib
    1. Read nib file; using ibtool
    2. Generate objects map
        1. Generate constraints map
    3. Generate a hierarchy map

### Generate Swift file

Using the maps, produce a swift file containing a view, it's subviews and constraints

```
public class __View Name__: UIView {
    private lazy var __Subview 1 Name__: __Subview 1 Name Class__ = {
        let view = __Subview 1 Name Class__
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func setupSubviews() {
        addSubview(__Subview 1 Name__)
        layout__Subview 1 Name__()
    }
    
    private func layout__Subview 1 Name__() {
        // Layout margins
    }
}
```

## Technical Design

### Read Nib

- Read file
  - Use IBTool to read
- Map from plist output to classes dictionary
- Generate view class
- Generate layout subview routine
- Generate constraints
- Write Swift file
