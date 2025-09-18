#!/usr/bin/env python3
"""
Example usage of FDB Query functionality.

This script demonstrates various use cases for finding data differences
between database tables.
"""

from fdb_query import FDBQuery


def example_basic_usage():
    """Demonstrate basic usage of FDB Query."""
    print("=== Example 1: Basic Usage ===")
    
    fdb = FDBQuery()
    fdb.create_sample_tables()
    fdb.insert_sample_data()
    
    # Find differences
    differences = fdb.find_data_not_in_table_b()
    print(f"Found {len(differences)} records in table A but not in table B:")
    for record in differences:
        print(f"  ID: {record[0]}, Name: {record[1]}, Value: {record[2]}")
    
    fdb.close()
    print()


def example_custom_comparison():
    """Demonstrate using custom columns for comparison."""
    print("=== Example 2: Custom Column Comparison ===")
    
    fdb = FDBQuery()
    fdb.create_sample_tables()
    
    # Insert custom data for this example
    cursor = fdb.connection.cursor()
    
    # Table A: Products with prices
    table_a_data = [
        (1, 'laptop', '1000'),
        (2, 'mouse', '25'),
        (3, 'keyboard', '75'),
        (4, 'monitor', '300')
    ]
    
    # Table B: Products with different prices (same names)
    table_b_data = [
        (1, 'laptop', '950'),  # Different price
        (2, 'mouse', '25'),    # Same price
        (5, 'speaker', '50')   # Different product
    ]
    
    cursor.executemany("INSERT INTO table_a (id, name, value) VALUES (?, ?, ?)", table_a_data)
    cursor.executemany("INSERT INTO table_b (id, name, value) VALUES (?, ?, ?)", table_b_data)
    fdb.connection.commit()
    
    # Compare by name only (ignore price differences)
    print("Comparing by 'name' column only:")
    differences = fdb.find_data_not_in_table_b(['name'])
    for record in differences:
        print(f"  Product not in B: {record[1]} (${record[2]})")
    
    # Compare by both name and value
    print("\nComparing by 'name' and 'value' columns:")
    differences = fdb.find_data_not_in_table_b(['name', 'value'])
    for record in differences:
        print(f"  Product with different price: {record[1]} (${record[2]})")
    
    fdb.close()
    print()


def example_file_database():
    """Demonstrate using a file-based database."""
    print("=== Example 3: File-based Database ===")
    
    # Use a file database
    fdb = FDBQuery("example.db")
    fdb.create_sample_tables()
    fdb.insert_sample_data()
    
    print("Using file database: example.db")
    
    # Show table contents
    print("Table A has", len(fdb.get_table_contents("table_a")), "records")
    print("Table B has", len(fdb.get_table_contents("table_b")), "records")
    
    # Find differences
    differences = fdb.find_data_not_in_table_b()
    print(f"Records in A but not B: {len(differences)}")
    
    fdb.close()
    
    # Clean up
    import os
    if os.path.exists("example.db"):
        os.remove("example.db")
        print("Cleaned up example.db")
    
    print()


def example_bidirectional_comparison():
    """Demonstrate finding differences in both directions."""
    print("=== Example 4: Bidirectional Comparison ===")
    
    fdb = FDBQuery()
    fdb.create_sample_tables()
    fdb.insert_sample_data()
    
    # Find what's in A but not B
    a_not_b = fdb.find_data_not_in_table_b()
    print(f"Records in A but not in B: {len(a_not_b)}")
    for record in a_not_b:
        print(f"  {record[1]}")
    
    # Find what's in B but not A
    b_not_a = fdb.find_data_not_in_table_a()
    print(f"\nRecords in B but not in A: {len(b_not_a)}")
    for record in b_not_a:
        print(f"  {record[1]}")
    
    # Summary
    total_unique = len(a_not_b) + len(b_not_a)
    print(f"\nTotal unique records across both tables: {total_unique}")
    
    fdb.close()
    print()


def main():
    """Run all examples."""
    print("FDB Query Examples\n")
    
    example_basic_usage()
    example_custom_comparison()
    example_file_database()
    example_bidirectional_comparison()
    
    print("All examples completed!")


if __name__ == "__main__":
    main()