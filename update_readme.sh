#!/bin/bash

# Define the output file
README_FILE="README.md"

# Start writing to README.md
cat > $README_FILE <<EOL
# 📘 LeetCode C++ Solutions

This repository contains categorized **LeetCode solutions in C++**, structured for easy navigation and reference.  
Each problem is **organized by topic**, making it easier to find and practice specific algorithms.

---

## 📂 Categories
Each category contains problems and their solutions. Click on a section to expand it.

EOL

# Function to generate markdown links with relative paths inside collapsible sections
generate_index() {
    local folder=$1
    local is_first_level=$2
    local has_files=0
    local folder_name=$(basename "$folder")

    # Create collapsible section for first-level directories
    if [[ $is_first_level -eq 1 ]]; then
        echo "<details>" >> $README_FILE
        echo "<summary><strong>$folder_name</strong></summary>" >> $README_FILE
        echo "" >> $README_FILE
    fi

    for item in "$folder"/*; do
        local relative_path="${item#./}"  # Remove the leading './' to get relative paths

        if [[ -d "$item" ]]; then
            generate_index "$item" 0 # Recursively add sub-files
        elif [[ -f "$item" && "$item" == *.md ]]; then
            # If it's a markdown file, format the relative path correctly
            encoded_path=$(echo "$relative_path" | sed 's/ /%20/g')  # Replace spaces with %20
            file_name=$(basename "$item")
            echo "- [$file_name]($encoded_path)" >> $README_FILE
            has_files=1
        fi
    done

    # Close collapsible section if it's a first-level directory
    if [[ $is_first_level -eq 1 ]]; then
        echo "" >> $README_FILE
        echo "</details>" >> $README_FILE
        echo "" >> $README_FILE
    fi
}

# Start scanning from the current directory, ensuring relative paths
for folder in *; do
    if [[ -d "$folder" ]]; then
        generate_index "$folder" 1
    fi
done

# Append additional sections
cat >> $README_FILE <<EOL
---

## 🚀 How to Use

### **💻 Running a Solution**
To **compile and run** LeetCode-style C++ code **locally**, you need to:
1. **Wrap the \`Solution\` class** inside a \`main()\` function.
2. **Include necessary headers** (\`#include <iostream>, <vector>, <unordered_map>\`)
3. **Provide input handling** for the \`twoSum()\` function.
4. **Compile and run** the program.

---

### **✅ Steps**
1. **Create a file**: \`two_sum.cpp\`
2. **Add a \`main()\` function** to call \`Solution::twoSum()\`.
3. **Compile using \`g++\`**.
4. **Run the executable**.

---

### **📝 Full Working Code (\`two_sum.cpp\`)**
\`\`\`cpp
#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int, int> m;
        for (int i = 0; i < nums.size(); ++i) {
            int complement = target - nums[i];
            if (m.count(complement)) return {m[complement], i};
            m[nums[i]] = i;
        }
        return {};
    }
};

int main() {
    Solution solution;

    // Input handling
    vector<int> nums;
    int target, n;

    cout << "Enter number of elements: ";
    cin >> n;
    
    cout << "Enter elements: ";
    nums.resize(n);
    for (int i = 0; i < n; i++) cin >> nums[i];

    cout << "Enter target: ";
    cin >> target;

    // Run twoSum function
    vector<int> result = solution.twoSum(nums, target);

    // Output result
    if (!result.empty()) {
        cout << "Indices: [" << result[0] << ", " << result[1] << "]" << endl;
    } else {
        cout << "No solution found!" << endl;
    }

    return 0;
}
\`\`\`

---

### **🔧 Compilation & Execution**
#### **1️⃣ Compile the C++ Code**
\`\`\`bash
g++ -std=c++17 two_sum.cpp -o two_sum
\`\`\`

#### **2️⃣ Run the Program**
\`\`\`bash
./two_sum
\`\`\`

---

### **🎯 Example Run**
#### **Input**
\`\`\`
Enter number of elements: 4
Enter elements: 2 7 11 15
Enter target: 9
\`\`\`
#### **Output**
\`\`\`
Indices: [0, 1]
\`\`\`

---

### **📌 Summary**
✅ **Wraps the LeetCode \`Solution\` class** inside \`main()\`  
✅ **Handles user input** for array and target  
✅ **Compiles and runs locally** using \`g++\`  
✅ **Displays output in a readable format**  

🚀 **Now you can test LeetCode C++ solutions locally!** 🚀

---

## 🛠 Automate \`README.md\` Update
This repository includes a script to **automatically update** \`README.md\` with new files and folders.

### 📝 Script: \`update_readme.sh\`
1. **Make the script executable**:
   \`\`\`bash
   chmod +x update_readme.sh
   \`\`\`
2. **Run the script**:
   \`\`\`bash
   ./update_readme.sh
   \`\`\`

### ✅ Features
- **Scans directories** for new solutions.
- **Uses collapsible sections** (\`<details>\`) for categories.
- **Formats relative links** (spaces encoded as \`%20\` for GitHub compatibility).
- **Automatically updates \`README.md\`** when new files are added.

---

## 📜 License
This project is licensed under the **MIT License**.  
See the full license [here](LICENSE).

---

## 🤝 Contributing
Want to contribute? Here's how:
- **Add a new solution** in the appropriate category.
- **Run \`update_readme.sh\`** to refresh \`README.md\`.
- **Submit a pull request** with your solution.

---

## 🔗 References
- [LeetCode](https://leetcode.com/)
- [GeeksforGeeks](https://www.geeksforgeeks.org/)
- [C++ Documentation](https://en.cppreference.com/w/)

---

**🚀 Happy Coding & Algorithm Solving!**
EOL

echo "✅ README.md updated successfully!"

