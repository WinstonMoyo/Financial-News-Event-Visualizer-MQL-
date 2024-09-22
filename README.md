# Financial-News-Event-Visualizer-MQL-
This project is a custom-built indicator for MetaTrader (MQL4/MQL5) that automatically parses financial news data from an external Excel/CSV file and plots key events on a financial chart. The indicator allows traders to visualize upcoming economic events in real time, with customizable line styles (color, width, and type) to enhance readability.

Key Features:
Excel/CSV File Parsing: Automatically reads and processes structured data (news event names, times, and descriptions) from an external file.

Time-Series Data Handling: Maps news events to specific timestamps and plots them on financial charts as vertical lines for easy reference during trading.

Customization Options: Provides user-configurable options for visualizing events, such as the ability to adjust line color, width, and style.

Efficient Data Structuring: Utilizes a custom struct to efficiently organize and manage the attributes of each news event, ensuring smooth performance and scalability.

Skills Demonstrated:
File I/O and Data Parsing: Efficiently reads and processes external files using MQL, with a focus on accurate parsing and error handling.

Object-Oriented Design: Uses data structures like structs and arrays to organize and manage complex data.

Real-Time Chart Plotting: Demonstrates experience working with time-sensitive data and building dynamic, event-driven visualizations in financial markets.

Customization & User Interface Interaction: Implements user-configurable options to enhance the usability and flexibility of the indicator.

This project showcases core software engineering skills like file management, object-oriented programming, and real-time system design, demonstrating proficiency in building tools for financial markets.

How to Run:

Place the NewsEventIndicator.mq4 file into the Indicators folder of your MetaTrader platform.

Import or link your financial news data in the form of an Excel/CSV file in the same format as the example file provided in this repository.

Place the CSV file in the Common/Files/ directory inside a folder named 'News Data'

In the MetaTrader 4 Terminal, type the name of the file and customize visualization options through the indicator’s settings to suit your trading style.
