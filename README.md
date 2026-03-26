# CollectionProject

A modern iOS app for collectors to catalog their collection and track loans.

## Features

- **Collection Management**: Add and view items (games, books, movies, board games)
- **Loan Tracking**: Lend items to friends and track return dates
- **Friend Management**: Maintain a list of friends
- **Modern UI**: Clean, card-based design with smooth navigation

## Architecture

- **MVVM Pattern**: Separation of concerns with ViewModels
- **Clean Architecture**: Mock repositories for data layer
- **SwiftUI**: Modern declarative UI framework

## Project Structure

```
LendMyGame/
├── Models/
│   ├── Item.swift
│   ├── Friend.swift
│   └── Loan.swift
├── ViewModels/
│   ├── CollectionViewModel.swift
│   ├── ItemDetailViewModel.swift
│   └── FriendsViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── CollectionView.swift
│   ├── ItemDetailView.swift
│   └── ...
├── Repositories/
│   ├── ItemRepository.swift
│   ├── FriendRepository.swift
│   └── LoanRepository.swift
├── AppDependencies.swift
└── LendMyGameApp.swift
```

## Getting Started

1. Open the project in Xcode
2. Build and run on iOS simulator or device
3. Add items to your collection
4. Add friends
5. Lend items and track loans

## Future Enhancements

- Real backend integration
- User authentication
- Image upload for covers
- Social features
- Shared loans between users