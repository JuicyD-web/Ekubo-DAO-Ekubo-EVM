#!/usr/bin/env python3
"""
Monitor and list all forks of the Ekubo Protocol EVM repository.

This script fetches fork information from GitHub and displays it in a readable format.
Useful for tracking who has forked the repository for license compliance monitoring.

Usage:
    python monitor_forks.py [--token GITHUB_TOKEN] [--output json|table|csv]

Requirements:
    pip install requests tabulate

Environment Variables:
    GITHUB_TOKEN - GitHub personal access token (optional, increases rate limit)
"""

import os
import sys
import json
import argparse
from datetime import datetime
from typing import List, Dict, Any

try:
    import requests
except ImportError:
    print("Error: 'requests' module not found. Install with: pip install requests")
    sys.exit(1)

try:
    from tabulate import tabulate
except ImportError:
    print("Warning: 'tabulate' module not found. Install with: pip install tabulate")
    print("Falling back to basic output format.\n")
    tabulate = None


class ForkMonitor:
    """Monitor GitHub repository forks."""
    
    def __init__(self, owner: str, repo: str, token: str = None):
        self.owner = owner
        self.repo = repo
        self.token = token or os.getenv('GITHUB_TOKEN')
        self.base_url = "https://api.github.com"
        
    def _get_headers(self) -> Dict[str, str]:
        """Get HTTP headers for GitHub API requests."""
        headers = {
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        }
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"
        return headers
    
    def get_repo_info(self) -> Dict[str, Any]:
        """Get basic repository information including fork count."""
        url = f"{self.base_url}/repos/{self.owner}/{self.repo}"
        response = requests.get(url, headers=self._get_headers())
        response.raise_for_status()
        return response.json()
    
    def get_forks(self, per_page: int = 100) -> List[Dict[str, Any]]:
        """Fetch all forks of the repository."""
        forks = []
        page = 1
        
        while True:
            url = f"{self.base_url}/repos/{self.owner}/{self.repo}/forks"
            params = {
                "per_page": per_page,
                "page": page,
                "sort": "newest"  # Sort by newest first
            }
            
            response = requests.get(url, headers=self._get_headers(), params=params)
            response.raise_for_status()
            
            page_forks = response.json()
            if not page_forks:
                break
                
            forks.extend(page_forks)
            page += 1
            
            # Check rate limiting
            remaining = int(response.headers.get('X-RateLimit-Remaining', 0))
            if remaining < 5:
                print(f"Warning: GitHub API rate limit approaching (remaining: {remaining})")
                break
        
        return forks
    
    def format_fork_data(self, forks: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Format fork data for display."""
        formatted = []
        
        for fork in forks:
            formatted.append({
                "owner": fork["owner"]["login"],
                "repo_name": fork["name"],
                "full_name": fork["full_name"],
                "url": fork["html_url"],
                "created_at": fork["created_at"],
                "updated_at": fork["updated_at"],
                "stars": fork["stargazers_count"],
                "watchers": fork["watchers_count"],
                "forks": fork["forks_count"],
                "open_issues": fork["open_issues_count"],
                "default_branch": fork["default_branch"],
                "private": fork["private"],
                "description": fork.get("description", "")
            })
        
        return formatted
    
    def display_table(self, forks: List[Dict[str, Any]]):
        """Display forks as a table."""
        if not forks:
            print("No forks found.")
            return
        
        # Prepare data for table
        table_data = []
        for fork in forks:
            table_data.append([
                fork["owner"],
                fork["repo_name"],
                fork["stars"],
                fork["forks"],
                fork["created_at"][:10],  # Just date
                fork["url"]
            ])
        
        headers = ["Owner", "Repo Name", "Stars", "Forks", "Created", "URL"]
        
        if tabulate:
            print(tabulate(table_data, headers=headers, tablefmt="grid"))
        else:
            # Fallback to simple format
            print(f"\n{'=' * 120}")
            print(f"{headers[0]:<20} {headers[1]:<30} {headers[2]:<8} {headers[3]:<8} {headers[4]:<12} {headers[5]}")
            print(f"{'=' * 120}")
            for row in table_data:
                print(f"{row[0]:<20} {row[1]:<30} {row[2]:<8} {row[3]:<8} {row[4]:<12} {row[5]}")
            print(f"{'=' * 120}\n")
    
    def display_json(self, forks: List[Dict[str, Any]]):
        """Display forks as JSON."""
        print(json.dumps(forks, indent=2))
    
    def display_csv(self, forks: List[Dict[str, Any]]):
        """Display forks as CSV."""
        if not forks:
            print("No forks found.")
            return
        
        # Print header
        headers = ["owner", "repo_name", "full_name", "url", "created_at", "updated_at", 
                   "stars", "watchers", "forks", "open_issues", "private", "description"]
        print(",".join(headers))
        
        # Print rows
        for fork in forks:
            row = [str(fork.get(h, "")) for h in headers]
            # Escape quotes in description
            row[-1] = f'"{row[-1].replace(chr(34), chr(34)+chr(34))}"'
            print(",".join(row))


def main():
    parser = argparse.ArgumentParser(
        description="Monitor forks of the Ekubo Protocol EVM repository"
    )
    parser.add_argument(
        "--token",
        help="GitHub personal access token (or set GITHUB_TOKEN env var)",
        default=None
    )
    parser.add_argument(
        "--output",
        choices=["table", "json", "csv"],
        default="table",
        help="Output format (default: table)"
    )
    parser.add_argument(
        "--owner",
        default="JuicyD-web",
        help="Repository owner (default: JuicyD-web)"
    )
    parser.add_argument(
        "--repo",
        default="Ekubo-DAO-Ekubo-EVM",
        help="Repository name (default: Ekubo-DAO-Ekubo-EVM)"
    )
    
    args = parser.parse_args()
    
    try:
        monitor = ForkMonitor(args.owner, args.repo, args.token)
        
        # Get repository info
        print(f"Fetching information for {args.owner}/{args.repo}...\n")
        repo_info = monitor.get_repo_info()
        
        print(f"Repository: {repo_info['full_name']}")
        print(f"Description: {repo_info.get('description', 'N/A')}")
        print(f"Total Forks: {repo_info['forks_count']}")
        print(f"Stars: {repo_info['stargazers_count']}")
        print(f"Watchers: {repo_info['watchers_count']}")
        print(f"Created: {repo_info['created_at'][:10]}")
        print(f"Last Updated: {repo_info['updated_at'][:10]}")
        print(f"\n{'=' * 80}\n")
        
        # Get forks
        print("Fetching forks (this may take a moment for popular repositories)...\n")
        forks = monitor.get_forks()
        formatted_forks = monitor.format_fork_data(forks)
        
        print(f"Found {len(forks)} forks\n")
        
        # Display based on output format
        if args.output == "table":
            monitor.display_table(formatted_forks)
        elif args.output == "json":
            monitor.display_json(formatted_forks)
        elif args.output == "csv":
            monitor.display_csv(formatted_forks)
        
        print(f"\nTotal forks displayed: {len(forks)}")
        
        # Check for rate limiting
        if not args.token and len(forks) > 50:
            print("\nTip: Set GITHUB_TOKEN environment variable or use --token to increase rate limits")
        
    except requests.exceptions.HTTPError as e:
        print(f"Error: HTTP {e.response.status_code} - {e.response.reason}")
        if e.response.status_code == 404:
            print("Repository not found. Check owner and repo name.")
        elif e.response.status_code == 403:
            print("Rate limit exceeded. Use a GitHub token to increase limits.")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
