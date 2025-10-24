# 📚 Bookstore POS Terminal

A feature-rich, responsive Point of Sale (POS) application built with Flutter, designed for a small bookstore, library, or cafe. This desktop-focused application provides a complete solution for managing sales, products, patrons, and viewing sales history.

![Sales Terminal](placeholder.png) <!-- TODO: Replace with a screenshot of your sales terminal -->

## ✨ Core Features

The application is split into two main sections: a Sales Terminal for daily operations and a Management Hub for administrative tasks.

### 🛒 Sales Terminal
- **Product Grid:** Browse and select products from a responsive grid.
- **Dynamic Filtering:** Filter products by category or search by name in real-time.
- **Shopping Cart:** Add items to a cart, adjust quantities, and see a running total.
- **Patron Management:**
    - Assign a sale to a registered patron or a walk-in customer.
    - Register new patrons directly from the sales screen.
    - Track and display outstanding patron dues.
- **Checkout Process:**
    - Calculates subtotal, sales tax (8%), and grand total.
    - A payment dialog to enter the amount paid.
    - Automatically updates a patron's balance if the full amount isn't paid.
- **Responsive UI:** The layout intelligently adapts for different screen sizes, using a side-by-side view on desktops and a draggable bottom sheet for the cart on smaller screens.

### ⚙️ Management Hub
- **Product CRUD:** Full Create, Read, Update, and Delete functionality for all catalogue items (e.g., books, beverages, supplies).
- **Category CRUD:** Manage the sections and categories that products belong to.
- **Patron CRUD:** A complete system for managing patron records, including their contact information and account balance.
- **Dues Payment:** A dedicated interface to record payments made by patrons against their outstanding dues.
- **Sales Ledger:** A detailed history of all transactions. Includes search functionality and the ability to view a detailed receipt for any past sale.
- **Revenue Dashboard:** A simple card that displays the total revenue from all recorded sales.

## 🛠️ Technical Details

- **Framework:** Built with [Flutter](https://flutter.dev/) for a high-performance, cross-platform experience.
- **State Management:** Uses `setState` for simple, localized state management within widgets.
- **Data Persistence:**
    - Currently uses a **simulated** `SharedPreferences` service (`SharedPreferencesService`).
    - This service uses an in-memory map to store data, meaning **data will reset every time the application is closed**. This is designed for demonstration and can be swapped out for a real database solution.
- **Architecture:** The entire application is currently contained within `lib/main.dart`. It is structured with clear data models, services, and widget components, making it ready for refactoring into separate files.

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

Ensure you have the Flutter SDK installed on your machine. For installation instructions, see the official Flutter documentation.

### Installation & Running

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    ```

2.  **Navigate to the project directory:**
    ```sh
    cd bookstore_pos
    ```

3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

4.  **Run the application:**
    This project is configured for Windows and Linux. Run it on your desired desktop platform.
    ```sh
    flutter run -d windows
    # or
    flutter run -d linux
    ```

## 🔮 Future Improvements

This project has a solid foundation but can be extended in several ways:

- **Refactor UI:** Break down the large `main.dart` file into smaller, reusable widget files (e.g., `/widgets`, `/screens`).
- **Implement Real Database:** Replace the mock `SharedPreferencesService` with a persistent storage solution like SQLite (for desktop) or Hive.
- **Advanced State Management:** Introduce a more robust state management solution like Provider or Riverpod to better manage app-wide state.
- **Add Testing:** Implement unit, widget, and integration tests to ensure code quality and reliability.
- **Receipt Printing:** Integrate functionality to print physical or PDF receipts.

---

*This README was generated for the Vintage Bookstore POS project.*